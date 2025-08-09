#!/usr/bin/env python3
"""
QNX WhatWeb - Web Technology Fingerprinting Tool
A Python implementation inspired by WhatWeb for BlackBerry QNX 8 ARM

Author: QNX Cross-Compilation Project
License: MIT
"""

import urllib.request
import urllib.parse
import urllib.error
import http.client
import json
import re
import sys
import argparse
from html.parser import HTMLParser

# Try to import SSL, but handle gracefully if not available
try:
    import ssl
    SSL_AVAILABLE = True
except ImportError:
    SSL_AVAILABLE = False
    print("Warning: SSL module not available. HTTPS support may be limited.", file=sys.stderr)

# Handle typing imports gracefully for older Python versions
try:
    from typing import Dict, List, Optional, Any
except ImportError:
    # For Python < 3.5, define basic type hints as no-ops
    Dict = List = Optional = Any = lambda x: x

# Handle dataclasses for older Python versions
try:
    from dataclasses import dataclass
except ImportError:
    # Simple dataclass replacement for older Python
    def dataclass(cls):
        return cls

@dataclass
class DetectionResult:
    """Represents a technology detection result"""
    def __init__(self, name, version=None, category=None, confidence=100, details=None):
        self.name = name
        self.version = version
        self.category = category
        self.confidence = confidence
        self.details = details or {}

class WebPageAnalyzer(HTMLParser):
    """HTML parser to extract metadata and analyze page structure"""
    
    def __init__(self):
        super().__init__()
        self.meta_tags = {}
        self.script_sources = []
        self.link_hrefs = []
        self.title = ""
        self.comments = []
        self.current_tag = None
        
    def handle_starttag(self, tag, attrs):
        self.current_tag = tag
        attrs_dict = dict(attrs)
        
        if tag == 'meta':
            name = attrs_dict.get('name', '').lower()
            content = attrs_dict.get('content', '')
            if name:
                self.meta_tags[name] = content
                
        elif tag == 'script':
            src = attrs_dict.get('src', '')
            if src:
                self.script_sources.append(src)
                
        elif tag == 'link':
            href = attrs_dict.get('href', '')
            rel = attrs_dict.get('rel', '')
            if href:
                self.link_hrefs.append({'href': href, 'rel': rel})
    
    def handle_data(self, data):
        if self.current_tag == 'title':
            self.title += data.strip()
    
    def handle_comment(self, data):
        self.comments.append(data.strip())

class QNXWhatWeb:
    """Main web fingerprinting engine"""
    
    def __init__(self, timeout=10, user_agent=None):
        self.timeout = timeout
        self.user_agent = user_agent or "QNX-WhatWeb/1.0"
        self.results = []
        
        # Initialize detection patterns
        self.patterns = self._load_detection_patterns()
    
    def _load_detection_patterns(self) -> Dict[str, Dict]:
        """Load web technology detection patterns"""
        # This is a simplified set of patterns based on common WhatWeb detections
        return {
            "Apache": {
                "header_patterns": [
                    {"header": "Server", "pattern": r"Apache[/\s]?([\d\.]+)?", "version_group": 1}
                ],
                "category": "Web Server"
            },
            "nginx": {
                "header_patterns": [
                    {"header": "Server", "pattern": r"nginx[/\s]?([\d\.]+)?", "version_group": 1}
                ],
                "category": "Web Server"
            },
            "IIS": {
                "header_patterns": [
                    {"header": "Server", "pattern": r"Microsoft-IIS[/\s]?([\d\.]+)?", "version_group": 1}
                ],
                "category": "Web Server"
            },
            "WordPress": {
                "meta_patterns": [
                    {"name": "generator", "pattern": r"WordPress\s?([\d\.]+)?", "version_group": 1}
                ],
                "body_patterns": [
                    {"pattern": r"wp-content", "confidence": 80},
                    {"pattern": r"wp-includes", "confidence": 70}
                ],
                "category": "CMS"
            },
            "jQuery": {
                "script_patterns": [
                    {"pattern": r"jquery[.-]?([\d\.]+)?.*\.js", "version_group": 1}
                ],
                "body_patterns": [
                    {"pattern": r"jQuery\s*v?([\d\.]+)", "version_group": 1}
                ],
                "category": "JavaScript Library"
            },
            "Bootstrap": {
                "script_patterns": [
                    {"pattern": r"bootstrap[.-]?([\d\.]+)?.*\.js", "version_group": 1}
                ],
                "link_patterns": [
                    {"pattern": r"bootstrap[.-]?([\d\.]+)?.*\.css", "version_group": 1}
                ],
                "category": "CSS Framework"
            },
            "PHP": {
                "header_patterns": [
                    {"header": "X-Powered-By", "pattern": r"PHP[/\s]?([\d\.]+)?", "version_group": 1}
                ],
                "category": "Programming Language"
            },
            "Express": {
                "header_patterns": [
                    {"header": "X-Powered-By", "pattern": r"Express", "confidence": 90}
                ],
                "category": "Web Framework"
            },
            "Cloudflare": {
                "header_patterns": [
                    {"header": "Server", "pattern": r"cloudflare", "confidence": 100},
                    {"header": "CF-Ray", "pattern": r".*", "confidence": 100}
                ],
                "category": "CDN"
            }
        }
    
    def scan_url(self, url: str) -> List[DetectionResult]:
        """Scan a URL and detect web technologies"""
        try:
            # Ensure URL has scheme
            if not url.startswith(('http://', 'https://')):
                url = 'http://' + url
            
            # Create request with custom headers
            req = urllib.request.Request(url)
            req.add_header('User-Agent', self.user_agent)
            
            # Handle SSL context for HTTPS if available
            if SSL_AVAILABLE and url.startswith('https://'):
                ctx = ssl.create_default_context()
                ctx.check_hostname = False
                ctx.verify_mode = ssl.CERT_NONE
                # Make the request with SSL context
                with urllib.request.urlopen(req, timeout=self.timeout, context=ctx) as response:
                    headers = dict(response.headers)
                    body = response.read().decode('utf-8', errors='ignore')
                    status_code = response.getcode()
            else:
                # Make the request without SSL context
                with urllib.request.urlopen(req, timeout=self.timeout) as response:
                    headers = dict(response.headers)
                    body = response.read().decode('utf-8', errors='ignore')
                    status_code = response.getcode()
                
            # Parse HTML content
            parser = WebPageAnalyzer()
            parser.feed(body)
            
            # Analyze and detect technologies
            results = []
            
            # Check each detection pattern
            for tech_name, patterns in self.patterns.items():
                detection = self._check_technology(tech_name, patterns, headers, body, parser)
                if detection:
                    results.append(detection)
            
            # Add basic server information
            if 'Server' in headers:
                results.append(DetectionResult(
                    name="Server",
                    version=headers['Server'],
                    category="Server Info",
                    confidence=100
                ))
            
            return results
            
        except urllib.error.URLError as e:
            print(f"Error accessing {url}: {e}")
            return []
        except Exception as e:
            print(f"Error analyzing {url}: {e}")
            return []
    
    def _check_technology(self, tech_name: str, patterns: Dict, headers: Dict, 
                         body: str, parser: WebPageAnalyzer) -> Optional[DetectionResult]:
        """Check if a technology is detected based on patterns"""
        version = None
        confidence = 100
        detected = False
        
        # Check header patterns
        if 'header_patterns' in patterns:
            for pattern_info in patterns['header_patterns']:
                header_name = pattern_info['header']
                pattern = pattern_info['pattern']
                
                if header_name in headers:
                    match = re.search(pattern, headers[header_name], re.IGNORECASE)
                    if match:
                        detected = True
                        if 'version_group' in pattern_info and len(match.groups()) >= pattern_info['version_group']:
                            version = match.group(pattern_info['version_group'])
                        confidence = pattern_info.get('confidence', 100)
        
        # Check meta tag patterns
        if 'meta_patterns' in patterns:
            for pattern_info in patterns['meta_patterns']:
                meta_name = pattern_info['name']
                pattern = pattern_info['pattern']
                
                if meta_name in parser.meta_tags:
                    match = re.search(pattern, parser.meta_tags[meta_name], re.IGNORECASE)
                    if match:
                        detected = True
                        if 'version_group' in pattern_info and len(match.groups()) >= pattern_info['version_group']:
                            version = match.group(pattern_info['version_group'])
                        confidence = pattern_info.get('confidence', 100)
        
        # Check body patterns
        if 'body_patterns' in patterns:
            for pattern_info in patterns['body_patterns']:
                pattern = pattern_info['pattern']
                match = re.search(pattern, body, re.IGNORECASE)
                if match:
                    detected = True
                    if 'version_group' in pattern_info and len(match.groups()) >= pattern_info['version_group']:
                        version = match.group(pattern_info['version_group'])
                    confidence = pattern_info.get('confidence', 100)
        
        # Check script patterns
        if 'script_patterns' in patterns:
            for pattern_info in patterns['script_patterns']:
                pattern = pattern_info['pattern']
                for script_src in parser.script_sources:
                    match = re.search(pattern, script_src, re.IGNORECASE)
                    if match:
                        detected = True
                        if 'version_group' in pattern_info and len(match.groups()) >= pattern_info['version_group']:
                            version = match.group(pattern_info['version_group'])
                        confidence = pattern_info.get('confidence', 100)
        
        # Check link patterns  
        if 'link_patterns' in patterns:
            for pattern_info in patterns['link_patterns']:
                pattern = pattern_info['pattern']
                for link in parser.link_hrefs:
                    match = re.search(pattern, link['href'], re.IGNORECASE)
                    if match:
                        detected = True
                        if 'version_group' in pattern_info and len(match.groups()) >= pattern_info['version_group']:
                            version = match.group(pattern_info['version_group'])
                        confidence = pattern_info.get('confidence', 100)
        
        if detected:
            return DetectionResult(
                name=tech_name,
                version=version,
                category=patterns.get('category', 'Unknown'),
                confidence=confidence
            )
        
        return None
    
    def format_results(self, url: str, results: List[DetectionResult], output_format='text') -> str:
        """Format detection results for output"""
        if output_format == 'json':
            data = {
                'url': url,
                'technologies': [
                    {
                        'name': r.name,
                        'version': r.version,
                        'category': r.category,
                        'confidence': r.confidence
                    } for r in results
                ]
            }
            return json.dumps(data, indent=2)
        
        elif output_format == 'text':
            output = [f"Scanning: {url}"]
            output.append("=" * 50)
            
            if not results:
                output.append("No technologies detected.")
                return "\n".join(output)
            
            # Group by category
            categories = {}
            for result in results:
                cat = result.category or "Unknown"
                if cat not in categories:
                    categories[cat] = []
                categories[cat].append(result)
            
            for category, techs in categories.items():
                output.append(f"\n{category}:")
                for tech in techs:
                    version_str = f" {tech.version}" if tech.version else ""
                    confidence_str = f" ({tech.confidence}%)" if tech.confidence < 100 else ""
                    output.append(f"  - {tech.name}{version_str}{confidence_str}")
            
            return "\n".join(output)

def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description="QNX WhatWeb - Web Technology Fingerprinting Tool",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 qnx_whatweb.py example.com
  python3 qnx_whatweb.py https://www.google.com --format json
  python3 qnx_whatweb.py site1.com site2.com --timeout 5
        """
    )
    
    parser.add_argument('urls', nargs='+', help='URLs to scan')
    parser.add_argument('--format', choices=['text', 'json'], default='text',
                       help='Output format (default: text)')
    parser.add_argument('--timeout', type=int, default=10,
                       help='Request timeout in seconds (default: 10)')
    parser.add_argument('--user-agent', default=None,
                       help='Custom User-Agent string')
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Verbose output')
    
    args = parser.parse_args()
    
    # Initialize scanner
    scanner = QNXWhatWeb(
        timeout=args.timeout,
        user_agent=args.user_agent
    )
    
    # Scan each URL
    for url in args.urls:
        if args.verbose:
            print(f"Scanning {url}...", file=sys.stderr)
        
        results = scanner.scan_url(url)
        output = scanner.format_results(url, results, args.format)
        print(output)
        
        if len(args.urls) > 1 and url != args.urls[-1]:
            print()  # Add spacing between multiple URLs

if __name__ == "__main__":
    main()
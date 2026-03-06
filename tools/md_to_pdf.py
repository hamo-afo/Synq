import sys
from pathlib import Path
import markdown
from xhtml2pdf import pisa

ROOT = Path(__file__).resolve().parent.parent
MD = ROOT / 'DATABASE_DESIGN.md'
PDF = ROOT / 'DATABASE_DESIGN.pdf'

if not MD.exists():
    print('Markdown file not found:', MD)
    sys.exit(1)

text = MD.read_text(encoding='utf-8')
# Convert Markdown to HTML
html = markdown.markdown(text, extensions=['fenced_code', 'tables'])
# Basic HTML wrapper
html = f"""<!doctype html>
<html>
<head>
<meta charset='utf-8'>
<style>
body { font-family: Arial, Helvetica, sans-serif; margin: 24px; }
h1,h2,h3 { color: #222 }
pre { background:#f6f8fa; padding:8px; }
table { border-collapse: collapse; width: 100%; }
table, th, td { border: 1px solid #ccc; padding: 6px; }
code { background:#f6f8fa; padding:2px 4px; }
</style>
</head>
<body>
{html}
</body>
</html>
"""

# Write PDF
with open(PDF, 'wb') as f:
    pisa_status = pisa.CreatePDF(html, dest=f)

if pisa_status.err:
    print('Failed to create PDF')
    sys.exit(2)

print('Created', PDF)

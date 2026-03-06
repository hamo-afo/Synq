from pathlib import Path
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm
from reportlab.lib.utils import simpleSplit
from reportlab.lib.utils import ImageReader

ROOT = Path(__file__).resolve().parent.parent
MD = ROOT / 'PROJECT_REPORT.md'
PDF = ROOT / 'PROJECT_REPORT.pdf'

if not MD.exists():
    print('Markdown file not found:', MD)
    raise SystemExit(1)

text = MD.read_text(encoding='utf-8')
lines = text.splitlines()

c = canvas.Canvas(str(PDF), pagesize=A4)
width, height = A4
x_margin = 18 * mm
y_margin = 18 * mm
max_width = width - x_margin * 2
y = height - y_margin

normal_font = 'Helvetica'
bold_font = 'Helvetica-Bold'
mono_font = 'Courier'

leading = 14

in_code = False
for raw in lines:
    line = raw.rstrip('\n')
    if line.strip().startswith('```'):
        in_code = not in_code
        if in_code:
            c.setFont(mono_font, 9)
        else:
            c.setFont(normal_font, 11)
            y -= 6
        continue

    if in_code:
        wrapped = simpleSplit(line, mono_font, 9, max_width)
        for w in wrapped:
            if y < y_margin:
                c.showPage()
                y = height - y_margin
                c.setFont(mono_font, 9)
            c.drawString(x_margin, y, w)
            y -= 11
        y -= 2
        continue

    # Headings
    if line.startswith('#'):
        level = len(line) - len(line.lstrip('#'))
        text_h = line.lstrip('# ').strip()
        font_size = max(18 - (level - 1) * 2, 12)
        font = bold_font
        if y < y_margin + font_size:
            c.showPage(); y = height - y_margin
        c.setFont(font, font_size)
        c.drawString(x_margin, y, text_h)
        y -= font_size + 6
        c.setFont(normal_font, 11)
        continue

    # Horizontal rule
    if set(line.strip()) == set('-') and len(line.strip()) >= 3:
        if y < y_margin + 6:
            c.showPage(); y = height - y_margin
        c.line(x_margin, y, width - x_margin, y)
        y -= 12
        continue

    # Blank line
    if line.strip() == '':
        y -= 8
        continue

    # Bullet or normal text
    prefix = ''
    if line.lstrip().startswith('- '):
        prefix = '• '
        content = line.lstrip()[2:]
    else:
        content = line

    # Image handling: markdown image syntax ![alt](path)
    if line.strip().startswith('![') and '(' in line and ')' in line:
        try:
            path = line[line.find('(')+1:line.find(')')]
            img_path = ROOT / path
            if img_path.exists():
                pil = ImageReader(str(img_path))
                iw, ih = pil.getSize()
                scale = min(max_width / iw, (height - 2 * y_margin) / ih, 1)
                draw_w = iw * scale
                draw_h = ih * scale
                if y - draw_h < y_margin:
                    c.showPage(); y = height - y_margin
                c.drawImage(pil, x_margin, y - draw_h, width=draw_w, height=draw_h)
                y -= draw_h + 12
                continue
        except Exception:
            pass

    wrapped = simpleSplit(prefix + content, normal_font, 11, max_width)
    for w in wrapped:
        if y < y_margin + leading:
            c.showPage(); y = height - y_margin
        c.drawString(x_margin, y, w)
        y -= leading

c.save()
print('Created', PDF)

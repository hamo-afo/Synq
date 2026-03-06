from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / 'assets'
ASSETS.mkdir(exist_ok=True)
OUT = ASSETS / 'db_diagram.png'

W, H = 1400, 900
img = Image.new('RGB', (W, H), 'white')
d = ImageDraw.Draw(img)

# Try to load a reasonable font; fallback to default
try:
    font_b = ImageFont.truetype('arialbd.ttf', 16)
    font = ImageFont.truetype('arial.ttf', 14)
except Exception:
    font_b = ImageFont.load_default()
    font = ImageFont.load_default()

# Boxes positions
# We'll compute box heights based on number of fields so all attributes fit inside
base_x = 60
boxes = {
    'users': (base_x, 80, 380),
    'trends': (420, 40, 980),
    'posts': (base_x, 260, 380),
    'comments': (420, 240, 760),
    'reports': (820, 240, 1180),
    'likes': (420, 420, 760),
    'admin_actions': (820, 420, 1180),
    'audit_logs': (60, 520, 380),
}

fields = {
    'users': ['uid (PK)', 'name', 'email', 'role', 'createdAt', 'isAdmin', 'banned'],
    'trends': ['id (PK)', 'type', 'title', 'date', 'likes', 'views', 'category', 'source'],
    'posts': ['postId (PK)', 'userId (FK -> users.uid)', 'title', 'content', 'createdAt', 'likes'],
    'comments': ['commentId (PK)', 'postId (FK -> posts.postId)', 'userId (FK -> users.uid)', 'content', 'createdAt'],
    'reports': ['reportId (PK)', 'userId (FK -> users.uid)', 'reportType', 'targetId', 'status', 'createdAt'],
    'likes': ['likeId (PK)', 'userId (FK -> users.uid)', 'targetType', 'targetId', 'createdAt'],
    'admin_actions': ['actionId (PK)', 'adminUid (FK -> users.uid)', 'actionType', 'targetType', 'targetId', 'notes', 'timestamp'],
    'audit_logs': ['logId (PK)', 'adminUid (FK -> users.uid)', 'action', 'targetType', 'targetId', 'before', 'after', 'timestamp'],
}

# Draw boxes and text
def measure_box_height(field_list, header_h=28, pad=12, line_h=18):
    return header_h + pad + len(field_list) * line_h + pad

# Draw boxes with dynamic heights
box_positions = {}
for name, (x1, y1, x2) in boxes.items():
    fld = fields.get(name, [])
    h = measure_box_height(fld)
    y2 = y1 + h
    d.rectangle([x1, y1, x2, y2], outline='black', width=2)
    # header band
    d.rectangle([x1, y1, x2, y1+28], fill='#EEEEEE', outline='black')
    d.text((x1+8, y1+6), name.upper(), font=font_b, fill='black')
    y = y1 + 32
    for f in fld:
        d.text((x1+10, y), f, font=font, fill='black')
        y += 18
    box_positions[name] = (x1, y1, x2, y2)

# Helper to draw arrow
def arrow(a, b):
    d.line([a, b], fill='black', width=2)
    # simple arrowhead
    ax, ay = a
    bx, by = b
    import math
    angle = math.atan2(by - ay, bx - ax)
    L = 10
    p1 = (bx - L * math.cos(angle - 0.3), by - L * math.sin(angle - 0.3))
    p2 = (bx - L * math.cos(angle + 0.3), by - L * math.sin(angle + 0.3))
    d.polygon([b, p1, p2], fill='black')


def label_between(a, b, text, offset=(0, -12)):
    # place label near midpoint of a->b with a small offset
    mx = (a[0] + b[0]) / 2 + offset[0]
    my = (a[1] + b[1]) / 2 + offset[1]
    d.rectangle([mx-4, my-12, mx+4+len(text)*7, my+4], fill='white')
    d.text((mx, my-10), text, font=font, fill='black')

# Draw relationships arrows
# Helper to get anchor points from computed boxes
def anchor(name, where='center'):
    x1, y1, x2, y2 = box_positions[name]
    if where == 'center':
        return ((x1+x2)//2, (y1+y2)//2)
    if where == 'top':
        return ((x1+x2)//2, y1)
    if where == 'bottom':
        return ((x1+x2)//2, y2)
    if where == 'left':
        return (x1, (y1+y2)//2)
    return (x2, (y1+y2)//2)

# users -> trends (admin write check)
arrow(anchor('users', 'right'), (box_positions['trends'][0], box_positions['trends'][1]+20))
label_between(anchor('users','right'), (box_positions['trends'][0], box_positions['trends'][1]+20), '1 (admin) -> *', offset=(10, -8))

# posts -> comments
arrow(anchor('posts','right'), anchor('comments','left'))
label_between(anchor('posts','right'), anchor('comments','left'), '1 (post) -> * (comments)', offset=(0, -10))

# users -> posts
arrow(anchor('users','bottom'), anchor('posts','top'))
label_between(anchor('users','bottom'), anchor('posts','top'), '1 (user) -> * (posts)', offset=(8, 0))

# users -> reports
arrow(anchor('users','center'), anchor('reports','left'))
label_between(anchor('users','center'), anchor('reports','left'), '1 (user) -> * (reports)', offset=(0, -16))

# Likes relations
# Likes relations
arrow(anchor('users','center'), anchor('likes','left'))
label_between(anchor('users','center'), anchor('likes','left'), '1 (user) -> * (likes)', offset=(-30, 6))
arrow(anchor('trends','bottom'), anchor('likes','top'))
label_between(anchor('trends','bottom'), anchor('likes','top'), '1 (trend/post/comment) -> * (likes)', offset=(40, 20))

# Admin actions relation
# Admin actions relation
arrow(anchor('users','center'), anchor('admin_actions','left'))
label_between(anchor('users','center'), anchor('admin_actions','left'), '1 (admin user) -> * (actions)', offset=(0, 6))

# Audit logs relation
arrow(anchor('admin_actions','bottom'), anchor('audit_logs','right'))
label_between(anchor('admin_actions','bottom'), anchor('audit_logs','right'), '1 (action) -> 1..* (audit entries)', offset=(0, 6))

# Title
title = 'Synq Firestore ER Diagram (Collections)'
bbox = d.textbbox((0, 0), title, font=font_b)
tw = bbox[2] - bbox[0]
d.text(((W - tw)//2, 10), title, font=font_b, fill='black')

img.save(OUT)
print('Saved diagram to', OUT)

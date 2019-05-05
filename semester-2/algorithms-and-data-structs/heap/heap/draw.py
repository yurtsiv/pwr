import math

vertical_offset = 80
         
def draw_heap(root, rel_side, parent_pos, curr_depth, static_params):
  if not root:
    return

  canvas, tree_size = static_params['canvas'], static_params['tree_size']

  horizontal_offset = None
  if curr_depth == 2:
    horizontal_offset = (tree_size * 50) / math.pow(curr_depth, 3.3)
  elif curr_depth == static_params['tree_depth']:
    horizontal_offset = 13 
  elif curr_depth == static_params['tree_depth'] - 1:
    horizontal_offset = 23
  else:
    horizontal_offset = (tree_size * 50) / math.pow(curr_depth, 2.7)

  new_pos = { 'y': parent_pos['y'] + vertical_offset, 'x': None }

  if curr_depth == 1:
    new_pos = parent_pos
  elif rel_side == 'left':
    new_pos['x'] = parent_pos['x'] - horizontal_offset 
  else:
    new_pos['x'] = parent_pos['x'] + horizontal_offset
  
  canvas.create_text(new_pos['x'], new_pos['y'], text=root.key, font=24)
  if curr_depth != 1:
    canvas.create_line(
      parent_pos['x'],
      parent_pos['y'] + 10,
      new_pos['x'],
      new_pos['y'] - 10
    )

  if not root.left and not root.right:
    return

  if root.left:
    draw_heap(root.left, 'left', new_pos, curr_depth+1, static_params)

  if root.right:
    draw_heap(root.right, 'right', new_pos, curr_depth+1, static_params)
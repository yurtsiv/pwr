def find_by(l, key):
  res = [item for item in l if key(item)]
  if res != []:
    return res[0]
  
  return None

def group_into_pairs(l):
  if l is None or l == [] or len(l) == 1:
    return []

  res = []
  list_len = len(l)
  for i in range(0, list_len, 2):
    if i == list_len - 1:
      res.append((l[i],))
    else:
      res.append((l[i], l[i + 1]))
  
  return res

def diff(l1, l2):
  return [x for x in l1 if x not in l2]
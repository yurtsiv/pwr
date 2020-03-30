import json
import uuid 
from datetime import datetime
from list_utils import find_by, diff

workers_file = "data/workers.json"
terminals_file = "data/terminals.json"
registrations_file = "data/registrations.json"
cards_file = "data/cards.json"

def read_data(path):
  f = open(path, "r")
  fContent = f.read()
  return json.loads(fContent)

def write_data(path, array):
  f = open(path, "w")
  jsonTxt = json.dumps(array, indent=2, default=str)
  f.write(jsonTxt)

workers = read_data(workers_file)
terminals = read_data(terminals_file)
registrations = read_data(registrations_file)
cards = read_data(cards_file)

def get_terminals():
  global terminals

  return terminals

def get_workers():
  global workers

  return workers

def get_cards():
  global cards
  
  return cards

def filter_workers(key):
  global workers

  return [w for w in workers if key(w)]

def get_workers_with_card():
  return filter_workers(lambda w: w.get('cardId') is not None)

def get_workers_with_no_card():
  return filter_workers(lambda w: w.get('cardId') is None)

def get_not_assigned_cards():
  global cards

  workers_with_cards = get_workers_with_card()
  assigned_cards = list(map(lambda w: w['cardId'], workers_with_cards))
  return diff(cards, assigned_cards)

def find_worker(key, val):
  global workers

  return find_by(workers, key=lambda worker: worker.get(key) == val)

def find_terminal(key, val):
  global terminals

  return find_by(terminals, key=lambda terminal: terminal.get(key) == val)

def find_registrations(key, val):
  global registrations

  return [r for r in registrations if r.get(key) == val]
  
def add_card(id):
  global cards

  if id in cards:
    raise "Card already registered"

  cards.append(id)
  write_data(cards_file, cards)

def delete_card(id):
  global cards

  cards.remove(id)
  write_data(cards_file, cards)

def add_terminal(name):
  global terminals

  id = uuid.uuid1().int
  terminal = { 'name': name, 'id': id }
  terminals.append(terminal)
  write_data(terminals_file, terminals)
  return terminal

def delete_terminal(id):
  global terminals

  terminals = list(filter(lambda t: t['id'] != id, terminals))
  write_data(terminals_file, terminals)

def add_worker(fullName):
  global workers

  id = uuid.uuid1().int
  workers.append({ 'fullName': fullName, 'id': id })
  write_data(workers_file, workers)

  
def delete_worker(id):
  global workers

  workers = list(filter(lambda t: t['id'] != id, workers))
  write_data(workers_file, workers)
  

def assign_card_id(workerId, cardId):
  global workers

  worker = find_worker("id", workerId)
  worker['cardId'] = cardId
  write_data(workers_file, workers)

def remove_card_id(workerId):
  global workers

  worker = find_worker("id", workerId)
  del worker['cardId']
  write_data(workers_file, workers)

def add_registration(terminalId, cardId):
  global workers
  global terminals
  global registrations
  global cards

  time = datetime.now()
  worker = find_worker("cardId", cardId)
  terminal = find_terminal("id", terminalId)
 
  if (not cardId in cards) or (worker is None ) or (terminal is None):
    print("Card ID or terminal isn't known to the system")
    registrations.append({ 'cardId': cardId, 'terminalId': terminalId, 'time': time })
  else:
    registrations.append({
      'cardId': cardId,
      'terminalId': terminalId,
      'workerId': worker['id'],
      'time': time
    })
  
  write_data(registrations_file, registrations)

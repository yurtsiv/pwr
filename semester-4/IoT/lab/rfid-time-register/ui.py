from data_handlers import *
from reports import generate_report
import sys, traceback

def input_int(min, max, label):
  while True:
    try:
      num = int(input("\n" + label))

      if num >= min and num <= max:
        return num

      print("Enter a number between " + str(min) + " and " + str(max))
    except Exception:
      print("Invalid input. Try again!")

def pick_from_list(l, label="Select an item: "):
  selected_item_index = input_int(1, len(l), label) - 1
  return l[selected_item_index]

def print_list(l):
  print("\n")
  for i in range(len(l)):
    print(str(i + 1) + ".  " + str(l[i]))

def print_and_pick_with_cancel(l, label="Select an item: "):
  print_list(l + ['Cancel'])
  picked_item = pick_from_list(l + [None], label=label)
  return picked_item

def add_terminal_menu():
  name = input("\nEnter terminal name: ")
  terminal = add_terminal(name)
  print("\nTerminal added")
  print(terminal)

def delete_terminal_menu():
  terminals = get_terminals()
  
  if terminals == []:
    print("No terminals")
  else:
    selected_terminal = print_and_pick_with_cancel(terminals, "Select terminal: ")
    if selected_terminal is None:
      return

    delete_terminal(selected_terminal['id'])
    print("\nTerminal deleted")

def assign_card_menu():
  cards = get_not_assigned_cards()
  workers = get_workers_with_no_card()

  if cards == []:
    print("\nAll cards are already assigned")
  elif workers == []:
    print("\nNo emplyees or all of them have card assigned")
  else:
    selected_worker = print_and_pick_with_cancel(workers, "Select employee: ")
    if selected_worker is None:
      return

    selected_card = print_and_pick_with_cancel(cards, "Select card: ")
    if selected_card is None:
      return

    assign_card_id(selected_worker['id'], selected_card)
    print("\nCard assigned")

def unassign_card_menu():
  workers = get_workers_with_card()

  if workers == []:
    print("\nNo employees to unassign card from")
  else:
    selected_worker = print_and_pick_with_cancel(workers, "Select worker: ")
    if selected_worker is None:
      return

    remove_card_id(selected_worker['id'])
    print("\nCard unassigned")

def register_menu():
  cards = get_cards()
  terminals = get_terminals()

  cards_select_items = [
    [-1, -1, -1, -1]
  ] + cards

  terminals_select_items = [
    {"id": -1, "name": "Unknown terminal"}
  ] + terminals

  selected_terminal = print_and_pick_with_cancel(terminals_select_items, "Select terminal: ")
  if selected_terminal is None:
    return

  selected_card = print_and_pick_with_cancel(cards_select_items, "Select card: ")
  if selected_card is None:
    return


  add_registration(selected_terminal["id"], selected_card)
  print("\nEmployee registered")

def report_menu():
  workers = get_workers()

  selected_worker = print_and_pick_with_cancel(workers, "Select worker: ")
  if selected_worker is None:
    return
  
  generate_report(selected_worker['id'])
  print("Report generated")

menu_items = [
  ("Add terminal", add_terminal_menu),
  ("Delete terminal", delete_terminal_menu),
  ("Assign card to employee", assign_card_menu),
  ("Unassign card from employee", unassign_card_menu),
  ("Register", register_menu),
  ("Generate report", report_menu)
]

def start_menu():
  print("\n")
  for i in range(len(menu_items)):
    print(str(i + 1) + ". " + menu_items[i][0])

  _, selected_func = pick_from_list(menu_items)
  selected_func()

def run_ui():
  while True:
    try:
      start_menu()
    except Exception:
      err_type, val, trace = sys.exc_info()
      traceback.print_exception(err_type, val, trace)

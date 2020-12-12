using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Linq;

namespace lab8
{
    public class ListOfArrayList<T> : IList<T>
    {
        private readonly List<List<T>> _lists;
        private readonly int _subListSize;
        private int _headSubListIndex;

        public ListOfArrayList(int size)
        {
            _headSubListIndex = 0;
            _subListSize = size;

            _lists = new List<List<T>>
            {
                new List<T>(size)
            };
        }

        public bool IsReadOnly { get => false; }

        public int Count => _lists.Select(subList => subList.Count).Sum();

        public T this[int index]
        {
            get
            {
                return _lists[index / _subListSize][index % _subListSize];
            }
            set
            {
                _lists[index / _subListSize][index % _subListSize] = value;
            }
        }

        public void Add(T item)
        {
            EnsureListCapacity();

            _lists[_headSubListIndex].Add(item);
        }
        public static ListOfArrayList<T> operator +(ListOfArrayList<T> current, IEnumerable<T> other)
        {
            foreach (var elem in other)
            {
                current.Add(elem);
            }

            return current;
        }

        private void EnsureListCapacity()
        {
            if (Count == _lists.Count * _subListSize)
            {
                _lists.Add(new List<T>());
                _headSubListIndex++;
            }
        }
        public bool Contains(T item) => _lists.Any(inner => inner.Contains(item));

        public void Clear()
        {
            _lists.Clear();
            _headSubListIndex = 0;
        }

        public void CopyTo(T[] array, int arrayIndex)
        {
            throw new NotImplementedException();
        }

        public IEnumerator<T> GetEnumerator()
        {
            foreach (var subList in _lists)
            {
                foreach (var element in subList)
                {
                    yield return element;
                }
            }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public int IndexOf(T item)
        {
            for (int subListIdx = 0; subListIdx < _lists.Count; subListIdx++)
            {
                var foundIndex = _lists[subListIdx].IndexOf(item);

                if (foundIndex != -1)
                {
                    return (_subListSize * subListIdx) + foundIndex;
                }
            }

            return -1;
        }

        public void Insert(int index, T item)
        {
            throw new NotImplementedException();
        }

        public bool Remove(T item)
        {
            var indexToRemove = IndexOf(item);

            if (indexToRemove != -1)
            {
                RemoveAt(indexToRemove);
                return true;
            }

            return false;
        }

        public void RemoveAt(int index)
        {
            if (index < Count)
            {
                _lists[index / _subListSize].RemoveAt(index % _subListSize);
                UpdateList(index);
            }
        }

        private void UpdateList(int index)
        {
            var removedListIndex = index / _subListSize;
            var nextListIndex = removedListIndex + 1;

            if (_lists.Count > nextListIndex && _lists[nextListIndex]?.Count > 0)
            {
                _lists[removedListIndex].Add(_lists[nextListIndex].FirstOrDefault());
                _lists[nextListIndex].RemoveAt(0);

                UpdateList(nextListIndex * _subListSize);
            }
        }

        public void Trim()
        {
            for (int i = _lists.Count - 1; i > 0; i--)
            {
                if (_lists[i].Count == 0)
                {
                    _lists.RemoveAt(i);
                }
            }
        }

        public override string ToString()
        {
            StringBuilder strBld = new StringBuilder();

            strBld.Append("\n[\n");

            foreach (var subList in _lists)
            {
                strBld.Append("  [ ");

                for (int i = 0; i < _subListSize; i++)
                {
                    string elem = i < subList.Count ? subList[i].ToString() : "null";
                    strBld.Append($" {elem}, ");
                }

                strBld.Append("]\n");
            }
            strBld.Append("]");

            return strBld.ToString();
        }
    }
}

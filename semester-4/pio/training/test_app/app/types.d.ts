export interface Student {
  surname: string,
  name: string,
  grades: Grade[]
}

export interface Subject {
  name: string
}

interface Grade {
  value: number
  subject: string
}

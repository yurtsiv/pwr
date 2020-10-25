export interface Student {
  name: string,
  grades: Grade[]
}

export type Subject = string

interface Grade {
  value: number
  subject: string
}

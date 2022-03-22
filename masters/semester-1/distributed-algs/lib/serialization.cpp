#define OPEN_REQUEST 1
#define READ_REQUEST 2
#define WRITE_REQUEST 3

struct read_request
{
  char filepath;
  char mode;
};

struct read_response
{
  int file_id;
};

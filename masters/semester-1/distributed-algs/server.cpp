#include <iostream>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>

using namespace std;

int main()
{
  int sockfd = socket(PF_INET, SOCK_DGRAM, 0);
  if (sockfd < 0)
  {
    cout << "Couldn't open the socket" << endl;
    exit(1);
  }

  cout << "Socket created" << endl;

  struct sockaddr_in server_addr;

  server_addr.sin_family = PF_INET;
  server_addr.sin_addr.s_addr = htons(INADDR_ANY);
  server_addr.sin_port = htons(5001);

  if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0)
  {
    cout << "Error binding socket" << endl;
    exit(1);
  }

  cout << "Socket binded" << endl;

  int bytes_read;
  char buf[512];
  struct sockaddr_in client_addr;
  socklen_t slen = sizeof(client_addr);

  do
  {
    bytes_read = recvfrom(sockfd, buf, sizeof(buf), 0, (struct sockaddr *)&client_addr, &slen);
    if (bytes_read > 0)
    {
      cout << "Received from address: " << inet_ntoa(client_addr.sin_addr) << endl;
      cout << buf << endl;
    }
  } while (bytes_read >= 0);

  return 0;
}
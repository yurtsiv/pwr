#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <string.h>

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

  char hello[65507] = {(char)12345, char(987)};

  int len = sendto(sockfd, &hello, sizeof(hello), 0,
                   (const struct sockaddr *)&server_addr, sizeof(server_addr));

  if (len < 0)
  {
    cout << "Failed to send packet" << endl;
  }

  close(sockfd);

  return 0;
}
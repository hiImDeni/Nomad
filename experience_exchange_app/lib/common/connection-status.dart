enum ConnectionStatus {
  Pending,
  Accepted,
  Declined
}

ConnectionStatus statusFromString(String status) {
  switch(status) {
    case 'Accepted':
      return ConnectionStatus.Accepted;
    case 'Pending':
      return ConnectionStatus.Pending;
    case 'Declined':
      return ConnectionStatus.Declined;
    default:
      return null;
  }
}
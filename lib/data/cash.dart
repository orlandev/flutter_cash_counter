const cashList = [
  1000,
  500,
  200,
  100,
  50,
  20,
  10,
  5,
  3,
  1,
];

class Cash {

  int calculateCant(Map<int, int> data) {
    var cashResult = 0;
    data.forEach((key, value) {
      cashResult += key * value;
    });
    return cashResult;
  }
}

import '../model/manual_model.dart';

class ManualDumy{
  final List<Manual> manuals = [
    const Manual(image:'https://search.pstatic.net/common/?src=http%3A%2F%2Fcafefiles.naver.net%2F20160908_139%2Fgreen4785_1473306763057rRlGm_JPEG%2F1473306751719.jpg&type=sc960_832' , title: '폭우', description: '이것은 폭우입니다.'),
    const Manual(image: 'https://tse1.mm.bing.net/th?id=OIP.144DvKjGQ77ApLoPFIEJ6AHaEm&pid=Api&P=0&h=220', title: '폭염', description: '폭염입니다.'),
    const Manual(image: 'https://tse2.mm.bing.net/th?id=OIP.XZTX5IPD37gNR9Ck2MAX1gHaEK&pid=Api&P=0&h=220', title: '태풍', description: '태풍입니다.'),
    const Manual(image: 'https://tse1.mm.bing.net/th?id=OIP.JghVheDalj1MH40rEAZXOQHaEK&pid=Api&P=0&h=220', title: '홍수', description: '홍수입니다.'),
    const Manual(image: 'https://tse2.mm.bing.net/th?id=OIP.zuRL3-QIOPjCnChCxrtYywHaE5&pid=Api&P=0&h=220', title: '대설', description: '대설입니다.'),
  ];

  List<Manual> getManuals(){
    return manuals;
  }
}
import 'package:flutter/material.dart';
import 'package:ballistic/review/review_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewPage extends StatefulWidget{
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();

}

class _ReviewPageState extends State<ReviewPage> {
  Future <List<Review>> fetchReviews(CookieRequest request) async {

    final response = await request.get('http://localhost:8000/review/json/');

    var data = response;


    //konversi dari json ke object Review
    List<Review> reviews = [];
    for (var d in data) {
      if (d != null) {
        reviews.add(Review.fromJson(d));
      }
    }
    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('This is the review page'),

          ],
        ),
      ),

      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchReviews(request),
        builder: (context, AsyncSnapshot<List<Review>> snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return Column(
                children: const [
                  Text(
                    "No Reviews Found",
                    style:
                        TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black, blurRadius: 2.0)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![index].title,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(snapshot.data![index].content),
                          ],
                        ),
                      ));
            }
          }
        },
      ),
    );
  }
}
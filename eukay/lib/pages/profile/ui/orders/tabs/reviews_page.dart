import 'package:eukay/components/containers/review_container.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserReviewPage extends StatefulWidget {
  const UserReviewPage({super.key});

  @override
  State<UserReviewPage> createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  String? token;
  late SharedPreferences pref;
  bool initializedPref = false;

  Future<void> _initPreferences() async {
    try {
      pref = await SharedPreferences.getInstance();
      setState(() {
        token = pref.getString('token');
        initializedPref = true;
      });
    } catch (e) {
      throw Exception("Failed to load preferences: $e");
    }
  }

  Future<void> _fetchReviews() async {
    context.read<ProfileBloc>().add(FetchReviewsEvent(token: token!));
  }

  @override
  void initState() {
    super.initState();
    _initPreferences().then((_) {
      _fetchReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initializedPref) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (BuildContext context, ProfileState state) {
        if (state is FetchReviewsFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is FetchReviewSuccessState) {
          final reviews = state.review;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];

              return ReviewContainer(
                productImage: review.productImage,
                productName: review.productName,
                review: review.review,
                starRating: review.starRating,
                userImage: review.userImage,
                userName: review.userName,
              );
            },
          );
        }

        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }
}

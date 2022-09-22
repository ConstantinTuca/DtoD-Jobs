import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jobs_app/screens/messages/messages_maintenance_screen.dart';
import 'package:jobs_app/screens/messages/messages_maintenance_screen.dart';
import 'package:provider/provider.dart';

import 'providers/jobs.dart';
import './screens/home_screen.dart';
import './screens/navigation_screen.dart';
import './widgets/color.dart';
import 'screens/offer_job/job_details_input_screen.dart';
import 'screens/offer_job/job_workers_input_screen.dart';
import 'screens/offer_job/job_location_input_screen.dart';
import 'screens/find_job/job_location_search_screen.dart';
import 'screens/offer_job/job_date_input_screen.dart';
import 'screens/find_job/job_date_search_screen.dart';
import 'screens/offer_job/job_hours_input_screen.dart';
import 'screens/find_job/job_hours_search_screen.dart';
import 'screens/find_job/job_speech_recognition_screen.dart';
import 'screens/offer_job/job_observations_input_screen.dart';
import 'screens/offer_job/job_post_success_screen.dart';
import 'screens/find_job/job_list_screen.dart';
import 'screens/authentification/login_screen.dart';
import 'screens/authentification/signup_screen.dart';
import 'screens/authentification/facebook_email_screen.dart';
import 'screens/profile/profile_details_screen.dart';
import 'screens/profile/profile_edit_screen.dart';
import 'screens/profile/change_password_screen.dart';
import 'screens/job/your_post_screen.dart';
import 'screens/job/job_plan_screen.dart';
import 'screens/job/job_details_edit_screen.dart';
import 'screens/job/job_workers_edit_screen.dart';
import 'screens/job/job_date_edit_screen.dart';
import 'screens/job/job_hours_edit_screen.dart';
import 'screens/job/job_location_edit_screen.dart';
import 'screens/job/job_delete_screen.dart';
import 'screens/job/posted_job_screen.dart';
import 'screens/job/job_candidate_success_screen.dart';
import 'screens/profile/public_profile_screen.dart';
import 'screens/user_job_list_history_screen.dart';
import 'screens/feedback/offer_feedback_screen.dart';
import 'screens/feedback/feedback_post_success_screen.dart';
import 'screens/feedback/feedback_list_screen.dart';
import 'screens/messages/messages_maintenance_screen.dart';

import './providers/auth.dart';
import './providers/jobs.dart';
import './providers/users.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Jobs>(
          update: (ctx, auth, previousJobs) => Jobs(
            auth.token,
            previousJobs == null ? [] : previousJobs.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Users(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Jobs App',
          theme: ThemeData(
            primarySwatch: colorCustom,
            bottomAppBarColor: colorCustom,
            accentColor: Colors.amber,
          ),
          home: auth.isAuth
              ? NavigationScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? Container()
                : LoginScreen(),
          ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            JobDetailsInputScreen.routeName: (ctx) => JobDetailsInputScreen(),
            JobWorkersInputScreen.routeName: (ctx) => JobWorkersInputScreen(),
            JobLocationInputScreen.routeName: (ctx) => JobLocationInputScreen(),
            JobLocationSearchScreen.routeName: (ctx) =>
                JobLocationSearchScreen(),
            JobDateInputScreen.routeName: (ctx) => JobDateInputScreen(),
            JobDateSearchScreen.routeName: (ctx) => JobDateSearchScreen(),
            JobHoursInputScreen.routeName: (ctx) => JobHoursInputScreen(),
            JobHoursSearchScreen.routeName: (ctx) => JobHoursSearchScreen(),
            JobListScreen.routeName: (ctx) => JobListScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            FacebookEmailScreen.routeName: (ctx) => FacebookEmailScreen(),
            ProfileDetailsScreen.routeName: (ctx) => ProfileDetailsScreen(),
            ProfileEditScreen.routeName: (ctx) => ProfileEditScreen(),
            ChangePasswordScreen.routeName: (ctx) => ChangePasswordScreen(),
            YourPostScreen.routeName: (ctx) => YourPostScreen(),
            JobPlanScreen.routeName: (ctx) => JobPlanScreen(),
            JobDetailsEditScreen.routeName: (ctx) => JobDetailsEditScreen(),
            JobWorkersEditScreen.routeName: (ctx) => JobWorkersEditScreen(),
            JobDateEditScreen.routeName: (ctx) => JobDateEditScreen(),
            JobHoursEditScreen.routeName: (ctx) => JobHoursEditScreen(),
            JobLocationEditScreen.routeName: (ctx) => JobLocationEditScreen(),
            JobDeleteScreen.routeName: (ctx) => JobDeleteScreen(),
            PostedJobScreen.routeName: (ctx) => PostedJobScreen(),
            PublicProfileScreen.routeName: (ctx) => PublicProfileScreen(),
            JobCandidateSuccessScreen.routeName: (ctx) => JobCandidateSuccessScreen(),
            JobObservationsInputScreen.routeName: (ctx) =>
                JobObservationsInputScreen(),
            JobPostSuccessScreen.routeName: (ctx) => JobPostSuccessScreen(),
            FeedbackPostSuccessScreen.routeName: (ctx) => FeedbackPostSuccessScreen(),
            JobSpeechRecognitionScreen.routeName: (ctx) => JobSpeechRecognitionScreen(),
            UserJobListHistoryScreen.routeName: (ctx) => UserJobListHistoryScreen(),
            OfferFeedbackScreen.routeName: (ctx) => OfferFeedbackScreen(),
            FeedbackListScreen.routeName: (ctx) => FeedbackListScreen(),
            MessagesMaintenanceScreen.routeName: (ctx) => MessagesMaintenanceScreen(),
          },
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (ctx) => NavigationScreen(),
            );
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (ctx) => NavigationScreen(),
            );
          },
        ),
      ),
    );
  }
}

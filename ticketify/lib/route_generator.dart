import 'package:go_router/go_router.dart';
import 'package:ticketify/pages/auth/auth_screen.dart';
import 'package:ticketify/pages/homepage/homepage.dart';
import 'package:ticketify/pages/homepage/one_item_view.dart';

class RouteGenerator {
  final String loginRoute = "/auth";
  //final String registerRoute = "/register";
  final String profileRoute = "/profile/:userId";

  final String displayAllEvents = "/display/all";
  // if type = buyer:
  final String displayOneItemRoute = "/display/:eventID";
  final String checkTickets = "/purchase/:eventID";

// ADMIN
  final String adminRoute = "/admin";
  final String reportCreateRoute = "/admin/report/create";
  final String reportDisplay = "/admin/report/display/all";
  final String oneReportDisplay = "/admin/report/display/:reportId";
// Worker Bee

// Organizor
  final String eventCreateRoute = "/event/create/:userId";
  final String venueCreateRoute = "/venue/create/:userId";


  getRouter() {
    return GoRouter(
      initialLocation: loginRoute,
      routes: [
        /*GoRoute(
          path: '/',
          builder: (context, state) {
            return const AuthScreen();
          },
        ),*/
        GoRoute(
            path: loginRoute,
            builder: (context, state) {
              return const AuthScreen();
            }),
        GoRoute(
          path: displayAllEvents,
          builder: (context, state) {
              return const Homepage();
          }),
        /*GoRoute(
            path: profileRoute,
            builder: (context, state) {
              final userId = state.pathParameters['userId'].toString();
              return UserProfilePage(userId: userId);
            }),*/
        GoRoute(
            path: displayOneItemRoute,
            builder: (context, state) {
              final itemId = state.pathParameters['eventID'].toString();
              return OneItemView(event_id: itemId,);
            }),
        /*GoRoute(
            path: questionHomepageRoute,
            builder: (context, state) {
              return const QuestionHomepage();
            }),
        GoRoute(
            path: questionCreateRoute,
            builder: (context, state) {
              return AddQuestionPage();
            }),
        GoRoute(
            path: studentCreateRoute,
            builder: (context, state) {
              return const StudentCreationPage();
            }),
        GoRoute(
            path: instructorRoute,
            builder: (context, state) {
              return const CourseHomePage();
            }),
        GoRoute(
            path: studentRoute,
            builder: (context, state) {
              return const CourseHomePage();
            }),
        GoRoute(
            path: adminRoute,
            builder: (context, state) {
              return Admin();
            }),*/
      ],
    );
  }
}

//import android.content.Context;
//import android.os.Bundle;
//import android.view.View;
//
//import io.flutter.embedding.android.SplashScreen;
//
//public class SplashScreenWithTransition implements SplashScreen {
//
//    private MySplashView mySplashView;
//
//    @Override
//    public View createSplashView(Context context, Bundle savedInstanceState)
//    {
//        // A reference to the MySplashView is retained so that it can be told
//        // to transition away at the appropriate time.
//        mySplashView = new MySplashView(context);
//        return mySplashView;
//    }
//
//    @Override
//    public void transitionToFlutter(Runnable onTransitionComplete) {
//        // Instruct MySplashView to animate away in whatever manner it wants.
//        // The onTransitionComplete Runnable is passed to the MySplashView
//        // to be invoked when the transition animation is complete.
//        mySplashView.animateAway(onTransitionComplete);
//    }
//}

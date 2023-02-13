NB. init

require 'jni api/expat'

coclass 'ja'
coinsert 'jni jaresu'

NB. get JNIENV
GetJNIENV''

jniImport (0 : 0)
android.app.Activity
android.app.AlertDialog
android.app.AlertDialog$Builder
android.content.Context
android.content.DialogInterface$OnClickListener
android.content.Intent
android.graphics.Bitmap
android.graphics.Bitmap$CompressFormat
android.graphics.BitmapFactory
android.graphics.Typeface
android.graphics.drawable.BitmapDrawable
android.graphics.drawable.Drawable
android.net.Uri
android.util.DisplayMetrics
android.view.Display
android.view.WindowManager
android.widget.Toast
java.io.ByteArrayOutputStream
java.io.FileOutputStream
java.io.OutputStream
)

jniImport^:IFQT (0 : 0)
org.qtproject.qt5.android.bindings.QtActivity
org.qtproject.qt5.android.bindings.QtApplication
)

jniImport^:(-.IFQT) (0 : 0)
com.jsoftware.j.android.AbstractActivity
com.jsoftware.j.android.JConsoleApp
com.jsoftware.jn.android.app.Activity
)

NB.      Platform Version      API Level      VERSION_CODE
NB. Android 5.1                22        LOLLIPOP_MR1
NB. Android 5.0                21        LOLLIPOP
NB. Android 4.4W               20        KITKAT_WATCH
NB. Android 4.4                19        KITKAT
NB. Android 4.3                18        JELLY_BEAN_MR2
NB. Android 4.2, 4.2.2         17        JELLY_BEAN_MR1
NB. Android 4.1, 4.1.1         16        JELLY_BEAN
NB. Android 4.0.3, 4.0.4       15        ICE_CREAM_SANDWICH_MR1
NB. Android 4.0, 4.0.1, 4.0.2  14        ICE_CREAM_SANDWICH
NB. Android 3.2                13        HONEYCOMB_MR2
NB. Android 3.1.x              12        HONEYCOMB_MR1
NB. Android 3.0.x              11        HONEYCOMB
NB. Android 2.3.4              10        GINGERBREAD_MR1
NB. Android 2.3.3
NB. Android 2.3.2
NB. Android 2.3.1              9         GINGERBREAD
NB. Android 2.3
NB. Android 2.2.x              8         FROYO
NB. Android 2.1.x              7         ECLAIR_MR1
NB. Android 2.0.1              6         ECLAIR_0_1
NB. Android 2.0                5         ECLAIR
NB. Android 1.6                4         DONUT
NB. Android 1.5                3         CUPCAKE
NB. Android 1.1                2         BASE_1_1
NB. Android 1.0                1         BASE

NB. multiple user space since APILEVEL 17
3 : 0''
APILEVEL=: 3
if. (0~:JNIENV) *. ('Android'-:UNAME) do.
  APILEVEL=: 0&". LF-.~ 2!:0 'getprop ro.build.version.sdk'
end.
if. 0~:4!:0<'UserNumber_ja_' do.
  UserNumber=: 0-APILEVEL<17  NB. assume user 0, but may need to overrided in startup.ijs per user
end.
)

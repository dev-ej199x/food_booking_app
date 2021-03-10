import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/blend_mask.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UiSample extends StatelessWidget {
  UiSample({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Container(
            width: 360.0,
            height: 634.0,
            decoration: BoxDecoration(
              color: const Color(0xff464444),
            ),
          ),
          Transform.translate(
            offset: Offset(-176.0, -7.0),
            child:
                // Adobe XD layer: 'R32105fa0747bbca1f0…' (shape)
                Container(
              width: 399.0,
              height: 259.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/Background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(180.0, -7.0),
            child:
                // Adobe XD layer: 'R32105fa0747bbca1f0…' (shape)
                Container(
              width: 399.0,
              height: 259.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/Background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0.0, 211.0),
            child: Container(
              width: 360.0,
              height: 548.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: const Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, -5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0.0, 224.0),
            child: Container(
              width: 360.0,
              height: 548.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: const Color(0xffeb4d4d),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, -5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(44.0, 305.0),
            child: Container(
              width: 271.0,
              height: 37.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0x40707070)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(46.0, 363.0),
            child: Container(
              width: 271.0,
              height: 37.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0x40707070)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(56.8, 369.2),
            child:
                // Adobe XD layer: 'lock' (group)
                SizedBox(
              width: 20.0,
              height: 24.0,
              child: Stack(
                children: <Widget>[
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(0.0, 0.0, 19.7, 23.8),
                    size: Size(19.7, 23.8),
                    pinLeft: true,
                    pinRight: true,
                    pinTop: true,
                    pinBottom: true,
                    child: SvgPicture.string(
                      _svg_cfcr9v,
                      allowDrawingOutsideViewBox: true,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(7.7, 13.2, 4.4, 6.1),
                    size: Size(19.7, 23.8),
                    fixedWidth: true,
                    fixedHeight: true,
                    child: SvgPicture.string(
                      _svg_hczhol,
                      allowDrawingOutsideViewBox: true,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(87.0, 313.0),
            child: Text(
              'Email',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xff707070),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(85.0, 370.0),
            child: Text(
              'Password',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xff707070),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(96.0, 529.0),
            child: Text(
              'Want to Create Account? ',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 11,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(214.0, 529.0),
            child: Text(
              'Click here',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 11,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(222.0, 401.0),
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 9,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(139.0, 460.0),
            child: Text(
              'Log In with:',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(57.5, 314.9),
            child: SvgPicture.string(
              _svg_2j75s9,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(162.6, 485.6),
            child:
                // Adobe XD layer: 'google' (group)
                BlendMask(
              blendMode: BlendMode.srcOver,
              region: Offset(162.6, 485.6) & Size(28.5, 28.5),
              child: SizedBox(
                width: 29.0,
                height: 29.0,
                child: Stack(
                  children: <Widget>[
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(13.5, 10.9, 15.0, 13.6),
                      size: Size(28.5, 28.5),
                      pinRight: true,
                      pinBottom: true,
                      fixedWidth: true,
                      fixedHeight: true,
                      child: SvgPicture.string(
                        _svg_si4ydx,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(2.5, 0.0, 21.2, 11.2),
                      size: Size(28.5, 28.5),
                      pinLeft: true,
                      pinTop: true,
                      fixedWidth: true,
                      fixedHeight: true,
                      child: SvgPicture.string(
                        _svg_5rv1j7,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(2.5, 17.4, 20.3, 11.2),
                      size: Size(28.5, 28.5),
                      pinLeft: true,
                      pinBottom: true,
                      fixedWidth: true,
                      fixedHeight: true,
                      child: SvgPicture.string(
                        _svg_ozitma,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(0.0, 7.8, 6.8, 12.9),
                      size: Size(28.5, 28.5),
                      pinLeft: true,
                      fixedWidth: true,
                      fixedHeight: true,
                      child: SvgPicture.string(
                        _svg_3f58ll,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(211.7, 482.9),
            child: SvgPicture.string(
              _svg_gh5sin,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(54.0, 242.0),
            child:
                // Adobe XD layer: 'Food Booking' (text)
                Text(
              'FOOD BOOKING',
              style: TextStyle(
                fontFamily: 'a Alloy Ink',
                fontSize: 33,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(122.0, 420.0),
            child: Container(
              width: 106.0,
              height: 28.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: const Color(0xff464444),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(147.0, 418.0),
            child: Text(
              'Log In',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 19,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_cfcr9v =
    '<svg viewBox="0.0 0.0 19.7 23.8" ><path transform="translate(-66.0, 0.0)" d="M 83.26573944091797 9.124210357666016 L 83.26573944091797 6.656949043273926 C 83.26573944091797 2.986268758773804 79.93967437744141 -3.376645508978982e-06 75.85132598876953 -3.376645508978982e-06 C 71.76296997070313 -3.376645508978982e-06 68.43692016601563 2.986268758773804 68.43692016601563 6.656949043273926 L 68.43692016601563 9.124210357666016 L 66.00000762939453 9.124210357666016 L 66.00000762939453 14.98977756500244 C 66.00000762939453 19.86685752868652 70.41925811767578 23.83468055725098 75.85132598876953 23.83468055725098 C 81.28338623046875 23.83468055725098 85.70265197753906 19.86685752868652 85.70265197753906 14.98977756500244 L 85.70265197753906 9.124210357666016 L 83.26573944091797 9.124210357666016 Z M 69.99238586425781 6.656949043273926 C 69.99238586425781 3.756333827972412 72.62066650390625 1.396560311317444 75.85132598876953 1.396560311317444 C 79.08198547363281 1.396560311317444 81.71026611328125 3.756333827972412 81.71026611328125 6.656949043273926 L 81.71026611328125 9.124210357666016 L 69.99238586425781 9.124210357666016 L 69.99238586425781 6.656949043273926 Z M 84.14716339111328 14.98977756500244 C 84.14716339111328 19.09679222106934 80.42570495605469 22.43811988830566 75.85132598876953 22.43811988830566 C 71.27693939208984 22.43811988830566 67.55548095703125 19.09679222106934 67.55548095703125 14.98977756500244 L 67.55548095703125 10.52077484130859 L 84.14716339111328 10.52077484130859 L 84.14716339111328 14.98977756500244 Z" fill="#908787" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_hczhol =
    '<svg viewBox="7.7 13.2 4.4 6.1" ><path transform="translate(-193.33, -252.83)" d="M 202.5888214111328 270.2866516113281 L 202.5888214111328 272.1433715820313 L 203.7804260253906 272.1433715820313 L 203.7804260253906 270.2866516113281 C 204.6963806152344 270.0266723632813 205.3692474365234 269.1827392578125 205.3692474365234 268.1846313476563 C 205.3692474365234 266.9800109863281 204.3892211914063 266 203.1846160888672 266 C 201.9800262451172 266 201 266.9800109863281 201 268.1846313476563 C 201 269.1827392578125 201.6728668212891 270.0267028808594 202.5888214111328 270.2866516113281 Z M 203.1846160888672 267.1916198730469 C 203.7321624755859 267.1916198730469 204.1776275634766 267.6370849609375 204.1776275634766 268.1846313476563 C 204.1776275634766 268.732177734375 203.7321624755859 269.1776123046875 203.1846160888672 269.1776123046875 C 202.6370849609375 269.1776123046875 202.1916198730469 268.732177734375 202.1916198730469 268.1846313476563 C 202.1916198730469 267.6370849609375 202.6370849609375 267.1916198730469 203.1846160888672 267.1916198730469 Z" fill="#908787" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_si4ydx =
    '<svg viewBox="13.5 10.9 15.0 13.6" ><path transform="translate(-228.52, -185.08)" d="M 257.0426330566406 199.3418579101563 C 257.0426330566406 198.4457702636719 256.9585876464844 197.548828125 256.7921142578125 196.6780395507813 C 256.7170104980469 196.2838439941406 256.3717956542969 195.9989929199219 255.9711303710938 195.9989929199219 L 242.8357086181641 195.9989929199219 C 242.3737945556641 195.9989929199219 242.0000152587891 196.3727874755859 242.0000152587891 196.8347015380859 L 242.0000152587891 201.8489074707031 C 242.0000152587891 202.3108367919922 242.3737945556641 202.6846313476563 242.8357086181641 202.6846313476563 L 249.5752105712891 202.6846313476563 C 249.1552886962891 203.5346984863281 248.5765991210938 204.2722930908203 247.8970489501953 204.892822265625 L 252.6204681396484 209.6162261962891 C 255.3382110595703 207.0269470214844 257.0426330566406 203.3832550048828 257.0426330566406 199.3418579101563 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_5rv1j7 =
    '<svg viewBox="2.5 0.0 21.2 11.2" ><path transform="translate(-42.17, 0.0)" d="M 56.43735504150391 6.685627937316895 C 58.07695007324219 6.685627937316895 59.63653564453125 7.206326961517334 60.94720458984375 8.192177772521973 C 61.27852630615234 8.441105842590332 61.74618530273438 8.410908699035645 62.03997039794922 8.114624977111816 L 65.60641479492188 4.548178672790527 C 65.77210998535156 4.382486343383789 65.86102294921875 4.154785633087158 65.85044097900391 3.920565605163574 C 65.83985137939453 3.68634557723999 65.73210144042969 3.46761417388916 65.55254364013672 3.316630601882935 C 63.00058746337891 1.177676558494568 59.76301574707031 3.785240551223978e-06 56.43736267089844 3.785240551223978e-06 C 51.54297637939453 3.785240551223978e-06 47.21910858154297 2.487836122512817 44.66302490234375 6.265102863311768 L 49.56848907470703 11.17056751251221 C 50.73880767822266 8.534424781799316 53.3719482421875 6.685627937316895 56.43736267089844 6.685627937316895 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ozitma =
    '<svg viewBox="2.5 17.4 20.3 11.2" ><path transform="translate(-42.17, -294.15)" d="M 56.43732070922852 322.6705627441406 C 59.62764739990234 322.6705627441406 62.5654182434082 321.6008605957031 64.93932342529297 319.8187561035156 L 60.12728118896484 315.0067138671875 C 59.02738571166992 315.6260070800781 57.770263671875 315.9849548339844 56.43732070922852 315.9849548339844 C 53.37190628051758 315.9849548339844 50.73877334594727 314.1361389160156 49.56845474243164 311.5 L 44.66298675537109 316.4054870605469 C 47.21907043457031 320.1827392578125 51.54294204711914 322.6705627441406 56.43732070922852 322.6705627441406 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_3f58ll =
    '<svg viewBox="0.0 7.8 6.8 12.9" ><path transform="translate(0.0, -132.46)" d="M 6.80730152130127 147.92236328125 C 6.743286609649658 147.5279541015625 6.685623168945313 147.1307678222656 6.685623168945313 146.7186584472656 C 6.685623168945313 146.3065490722656 6.743287086486816 145.9093627929688 6.80730152130127 145.5149841308594 L 1.563320279121399 140.27099609375 C 0.5711733102798462 142.2087097167969 -1.922076990013011e-06 144.3963012695313 -1.922076990013011e-06 146.7186584472656 C -1.922076990013011e-06 149.0410461425781 0.5711733102798462 151.2286376953125 1.563376069068909 153.1662902832031 L 6.80730152130127 147.92236328125 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_2j75s9 =
    '<svg viewBox="57.5 314.9 83.8 200.2" ><path transform="translate(57.49, 260.9)" d="M 15.57038879394531 70.04703521728516 L 4.766445636749268 70.04703521728516 C 2.138227701187134 70.04703521728516 0 67.90880584716797 0 65.28058624267578 L 0 58.76644515991211 C 0 56.13822937011719 2.138227701187134 54 4.766445636749268 54 L 15.57038879394531 54 C 18.1986083984375 54 20.33683586120605 56.13822937011719 20.33683586120605 58.76644515991211 L 20.33683586120605 65.28058624267578 C 20.33683586120605 67.90880584716797 18.1986083984375 70.04703521728516 15.57038879394531 70.04703521728516 Z M 4.766445636749268 55.58881759643555 C 3.014300346374512 55.58881759643555 1.588815212249756 57.01430130004883 1.588815212249756 58.76644515991211 L 1.588815212249756 65.28058624267578 C 1.588815212249756 67.03273010253906 3.014300346374512 68.45822143554688 4.766445636749268 68.45822143554688 L 15.57038879394531 68.45822143554688 C 17.32253456115723 68.45822143554688 18.74802017211914 67.03273010253906 18.74802017211914 65.28058624267578 L 18.74802017211914 58.76644515991211 C 18.74802017211914 57.01430130004883 17.32253456115723 55.58881759643555 15.57038879394531 55.58881759643555 L 4.766445636749268 55.58881759643555 Z M 13.07936573028564 63.42985534667969 L 17.00592422485352 60.43049240112305 C 17.35458946228027 60.16416549682617 17.42131996154785 59.66563415527344 17.15499496459961 59.31697082519531 C 16.88862991333008 58.96830749511719 16.39013862609863 58.90157318115234 16.04147338867188 59.16790008544922 L 12.11539268493652 62.16690826416016 C 10.98173236846924 63.03158187866211 9.398518562316895 63.03221893310547 8.264104843139648 62.16909408569336 L 4.459646701812744 59.21171188354492 C 4.113245487213135 58.94240570068359 3.614119052886963 59.00496673583984 3.344894409179688 59.35136795043945 C 3.075629949569702 59.69776916503906 3.138149738311768 60.19685363769531 3.484551191329956 60.46612167358398 L 7.291947841644287 63.42576599121094 C 7.293854713439941 63.42727661132813 7.295801162719727 63.42874526977539 7.297747135162354 63.43021392822266 C 8.148716926574707 64.07924652099609 9.168337821960449 64.40371704101563 10.18819904327393 64.40371704101563 C 11.20805835723877 64.40371704101563 12.22811794281006 64.07904815673828 13.07936573028564 63.42985534667969 Z" fill="#908787" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><defs><filter id="shadow"><feDropShadow dx="0" dy="3" stdDeviation="6"/></filter></defs><path transform="translate(110.0, 483.87)" d="M 31.25365257263184 15.62682342529297 C 31.25365257263184 6.995445251464844 24.25820350646973 0 15.62682628631592 0 C 6.99544620513916 0 0 6.995444774627686 0 15.62682342529297 C 0 24.25819969177246 6.995445728302002 31.25364685058594 15.62682628631592 31.25364685058594 C 15.71838855743408 31.25364685058594 15.80995178222656 31.25364685058594 15.90151596069336 31.24753952026367 L 15.90151596069336 19.08792114257813 L 12.544189453125 19.08792114257813 L 12.544189453125 15.17510986328125 L 15.90151596069336 15.17510986328125 L 15.90151596069336 12.29391574859619 C 15.90151596069336 8.954902648925781 17.94032669067383 7.135842800140381 20.91919136047363 7.135842800140381 C 22.34758186340332 7.135842800140381 23.57453155517578 7.239614009857178 23.92857551574707 7.288448333740234 L 23.92857551574707 10.78006649017334 L 21.87755393981934 10.78006649017334 C 20.25993347167969 10.78006649017334 19.94251441955566 11.54919910430908 19.94251441955566 12.67848110198975 L 19.94251441955566 15.16900634765625 L 23.81869888305664 15.16900634765625 L 23.31204795837402 19.08181571960449 L 19.94251441955566 19.08181571960449 L 19.94251441955566 30.64933013916016 C 26.47403907775879 28.77532958984375 31.25365257263184 22.76266670227051 31.25365257263184 15.62682342529297 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" filter="url(#shadow)"/></svg>';
const String _svg_gh5sin =
    '<svg viewBox="211.7 482.9 32.1 32.1" ><defs><filter id="shadow"><feDropShadow dx="0" dy="3" stdDeviation="6"/></filter></defs><path transform="translate(211.67, 482.92)" d="M 16.04977607727051 0 C 7.187102317810059 0 0 7.1871018409729 0 16.04977416992188 C 0 24.91244697570801 7.187102794647217 32.09954833984375 16.04977607727051 32.09954833984375 C 24.91245079040527 32.09954833984375 32.09955215454102 24.91244697570801 32.09955215454102 16.04977416992188 C 32.09955215454102 7.187101364135742 24.91245079040527 0 16.04977607727051 0 Z M 23.37793922424316 12.51393413543701 C 23.38504219055176 12.67189502716064 23.38847160339355 12.83058929443359 23.38847160339355 12.99001884460449 C 23.38847160339355 17.8578987121582 19.68313026428223 23.47127342224121 12.90696430206299 23.47152519226074 L 12.90720844268799 23.47152519226074 L 12.90696430206299 23.47152519226074 C 10.82653617858887 23.47152519226074 8.89060115814209 22.86172485351563 7.26030158996582 21.81673812866211 C 7.548549652099609 21.85077667236328 7.841938972473145 21.86767768859863 8.139002799987793 21.86767768859863 C 9.865060806274414 21.86767768859863 11.45348167419434 21.27893829345703 12.71447372436523 20.29076766967773 C 11.10180187225342 20.26088905334473 9.742116928100586 19.19582176208496 9.272893905639648 17.7320499420166 C 9.497467041015625 17.7751522064209 9.728407859802246 17.79866218566895 9.965228080749512 17.79866218566895 C 10.30147647857666 17.79866218566895 10.62719249725342 17.75335693359375 10.93674755096436 17.66886711120605 C 9.251100540161133 17.33139228820801 7.981293678283691 15.84166717529297 7.981293678283691 14.05781078338623 C 7.981293678283691 14.04115676879883 7.981293678283691 14.02621746063232 7.981783866882324 14.01078987121582 C 8.478196144104004 14.28679275512695 9.045877456665039 14.4528341293335 9.650288581848145 14.4714469909668 C 8.661140441894531 13.81144332885742 8.010930061340332 12.68318939208984 8.010930061340332 11.40504932403564 C 8.010930061340332 10.73010635375977 8.193381309509277 10.09777069091797 8.509791374206543 9.553357124328613 C 10.32646369934082 11.78243827819824 13.04142761230469 13.24841117858887 16.10315132141113 13.40245056152344 C 16.03996849060059 13.13257026672363 16.00739669799805 12.85142517089844 16.00739669799805 12.56244468688965 C 16.00739669799805 10.52879333496094 17.65728950500488 8.878903388977051 19.69167518615723 8.878903388977051 C 20.7513542175293 8.878903388977051 21.70842742919922 9.326825141906738 22.38067626953125 10.04291343688965 C 23.21994590759277 9.877360343933105 24.00803375244141 9.570745468139648 24.71996116638184 9.148783683776855 C 24.4444465637207 10.00862598419189 23.8606071472168 10.73010635375977 23.09994697570801 11.18635368347168 C 23.84517860412598 11.09720897674561 24.55538940429688 10.89957523345947 25.21539497375488 10.6061840057373 C 24.722412109375 11.34505081176758 24.09718322753906 11.99403190612793 23.37791061401367 12.51395702362061 Z M 23.37793922424316 12.51393413543701" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" filter="url(#shadow)"/></svg>';

import 'package:flutter/material.dart';
import 'package:only_kids/models/hairstyle.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/edit_gallery_page.dart';
import 'package:only_kids/services/hairstyles_service.dart';
import 'package:only_kids/widgets/spinner.dart';
import 'package:provider/provider.dart';

import '../localizations.dart';
import '../main.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final HairstylesService _hairstylesService = getIt.get<HairstylesService>();
  final PageController ctrl = PageController(viewportFraction: 0.8);
  int currentPage = 0;

  @override
  void initState() {
    ctrl.addListener(() {
      int next = ctrl.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    final UserProfile userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10ns.gallery),
        actions: <Widget>[
          if (userProfile != null && userProfile.admin)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => EditGalleryPage(),
                    ));
              },
            )
        ],
      ),
      body: StreamBuilder<List<Hairstyle>>(
          stream: _hairstylesService.getHairstyles(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Spinner();
            }

            List hairstyles = snapshot.data;
            return PageView.builder(
              controller: ctrl,
              itemCount: hairstyles.length,
              itemBuilder: (context, int currentIdx) {
                bool active = currentPage == currentIdx;
                return _buildHairstylePage(context, hairstyles[currentIdx], active);
              },
            );
          }),
    );
  }

  Widget _buildHairstylePage(BuildContext context, Hairstyle data, bool active) {
    final double blur = active ? 20 : 0;
    final double top = active ? 50 : 100;
    final double bottom = active ? 50 : 100;
    final double borderRadius = 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: bottom, right: 10, left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: DecorationImage(
          image: data.imageUrl != null ? NetworkImage(data.imageUrl) : AssetImage('assets/only_kids_logo.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: blur,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.black.withAlpha(0),
                Colors.black12,
                Colors.black45,
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: <Widget>[
                  Text(
                    data.name,
                    style: Theme.of(context).primaryTextTheme.display1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      data.price ?? '',
                      style: Theme.of(context).primaryTextTheme.body1,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

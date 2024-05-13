// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ProfileRowList extends StatelessWidget {
  final String _key;
  final String _value;

  const ProfileRowList(this._key, this._value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: _value != null
            ? _value.contains('+') &&
                        (_key.contains('Phone number') ||
                            _key.contains('Phone')) ||
                    _value.contains('@')
                ? InkWell(
                    onTap: () async {
                      if (_value.contains('+')) {
                        // ignore: deprecated_member_use
                        await canLaunch('tel:$_value')
                            // ignore: deprecated_member_use
                            ? await launch('tel:$_value')
                            : throw 'Couldnt laucnh $_value';
                      } else if (_value.contains('@')) {
                        // ignore: deprecated_member_use
                        await canLaunch('mailto:$_value')
                            // ignore: deprecated_member_use
                            ? await launch('mailto:$_value')
                            : throw 'Couldnt laucnh $_value';
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _key,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: const Color(0xff727fc8),
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(12),
                                    ),
                              ),
                              SizedBox(
                                height: 12.0.h,
                              ),
                              Container(
                                height: 0.2.h,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF828BB2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _value ?? 'NA',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: const Color(0xff727fc8),
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(12),
                                    ),
                              ),
                              SizedBox(
                                height: 12.0.h,
                              ),
                              Container(
                                height: 0.2.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF828BB2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _key,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xff727fc8),
                                    fontWeight: FontWeight.normal,
                                    fontSize: ScreenUtil().setSp(12),
                                  ),
                            ),
                            SizedBox(
                              height: 12.0.h,
                            ),
                            Container(
                              height: 0.2.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFF828BB2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _value ?? 'NA',
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xff727fc8),
                                    fontWeight: FontWeight.normal,
                                    fontSize: ScreenUtil().setSp(12),
                                  ),
                            ),
                            SizedBox(
                              height: 12.0.h,
                            ),
                            Container(
                              height: 0.2.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFF828BB2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
            : Container());
  }
}

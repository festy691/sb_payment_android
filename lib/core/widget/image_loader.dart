import 'dart:developer';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:lottie/lottie.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';

class CircleWidget extends StatelessWidget {
  Widget child;
  double? width;
  double? height;
  Color? background;
  CircleWidget({
    required this.child,
    this.width,
    this.height,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32), color: background),
      child: child,
    );
  }
}

// ignore: must_be_immutable
class ImageLoader extends StatelessWidget {
  ImageLoader(
      {this.width,
      this.height,
      // this.elevation = .0,
      this.curve = 20,
      this.path,
      this.file,
      this.color,
      this.dColor,
      this.borderColor,
      this.radius = 16,
      this.borderWidth = .0,
      this.isOnline = false,
      this.isCircular = false,
      this.isCurvedEdge = false,
      this.showInitialTextAbovePicture = false,
      this.onTap,
      this.fit = BoxFit.contain,
      Key? key})
      : super(key: key);

  double? elevation;
  double? width;
  double? height;
  double? borderWidth;
  double? radius;
  double? curve;
  String? path;
  File? file;
  Color? color;
  Color? dColor;
  Color? borderColor;
  bool? isOnline;
  Function()? onTap;
  BoxFit fit;
  bool isCircular;
  bool isCurvedEdge;
  bool showInitialTextAbovePicture;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      if (isCurvedEdge) {
        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height! / 2),
            child: Image.file(
              file!,
              width: width,
              height: height,
              fit: fit,
            ),
          ),
        );
      } else if (isCircular) {
        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius! / 2),
            child: Image.file(
              file!,
              width: width,
              height: height,
              fit: fit,
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Image.file(
            file!,
            width: width,
            height: height,
            fit: fit,
          ),
        );
      }
    } else if (path == null || path!.isEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 16.r),
          child: Image.asset(
            AppAssets.noImage,
            width: width,
            height: height,
            fit: fit,
          ),
        ),
      );
    } else if (path!.contains("http")) {
      if (isCircular) {
        return CircularProfileAvatar(path!,
            radius: radius!,
            backgroundColor: Pallet.colorPrimaryLight,
            borderWidth: borderWidth ?? 0.2,
            initialsText: const Text(
              "",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            borderColor:
                borderColor != null ? borderColor! : Colors.transparent,
            elevation: elevation ?? 0,
            foregroundColor: Colors.brown.withOpacity(0.5),
            onTap: onTap,
            showInitialTextAbovePicture: showInitialTextAbovePicture);
      }

      if (isCurvedEdge) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(curve!),
          child: GestureDetector(
            onTap: onTap,
            child: CachedNetworkImage(
              width: width ?? 1.sw,
              height: height ?? 1.sh,
              fit: fit,
              imageUrl: path!,
              imageBuilder: (context, imageProvider) => Container(
                width: width ?? 1.sw,
                height: height ?? 1.sh,
                decoration: BoxDecoration(
                  image: DecorationImage(image: imageProvider, fit: fit),
                ),
              ),
              fadeInDuration: Duration(seconds: 1),
              placeholderFadeInDuration: Duration(seconds: 1),
              progressIndicatorBuilder: (ctx, value, progress) => Center(
                  child: CircularProgressIndicator(
                value: progress.progress,
              )),
              errorWidget: (context, url, error) => ImageLoader(
                path: AppAssets.noImage,
                width: width ?? 1.sw,
                height: height ?? 1.sh,
              ),
            ),
          ),
        );
      }
      return GestureDetector(
        onTap: onTap,
        child: CachedNetworkImage(
          width: width != null ? width : 1.sw,
          height: height != null ? height : 1.sh,
          fit: fit,
          imageUrl: path!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: fit),
            ),
          ),
          fadeInDuration: Duration(seconds: 1),
          placeholderFadeInDuration: Duration(seconds: 1),
          progressIndicatorBuilder: (ctx, value, progress) {
            return Center(
                child: CircularProgressIndicator(
              value: progress.progress,
            ));
          },
          errorWidget: (context, url, error) => Center(child: Text('Error!')),
        ),
      );
    } else if (path!.contains(".json")) {
      return Lottie.asset(
        path!,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return Container(
        width: width,
        height: height,
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: color != null ? color : Colors.transparent,
            child: path!.contains(".svg")
                ? SvgPicture.asset(
                    path!,
                    width: width,
                    height: height,
                    color: dColor,
                    fit: fit,
                  )
                : isCircular
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          path!,
                          width: width,
                          height: height,
                          fit: fit,
                        ),
                      )
                    : Image.asset(
                        path!,
                        width: width,
                        height: height,
                        fit: fit,
                      ),
          ),
        ),
      );
    }
  }
}

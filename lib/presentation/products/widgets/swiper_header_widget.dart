import 'package:barista/models/product.dart';
import 'package:barista/presentation/products/widgets/custom_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SwiperHeaderWidget extends StatefulWidget {
  const SwiperHeaderWidget({
    super.key,
    required this.modelNotifier,
  });

  final ValueNotifier<ProductWithDirection> modelNotifier;

  @override
  State<SwiperHeaderWidget> createState() => _SwiperHeaderWidgetState();
}

class _SwiperHeaderWidgetState extends State<SwiperHeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHeader();
  }

  Widget _buildHeader() {
    return ValueListenableBuilder<ProductWithDirection>(
        valueListenable: widget.modelNotifier,
        builder:
            (BuildContext context, ProductWithDirection model, Widget? child) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              start: 20.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitlePageView(model),
                16.horizontalSpace,
                _buildPricePageView(model),
              ],
            ),
          );
        });
  }

  Widget _buildTitlePageView(ProductWithDirection model) {
    return Expanded(
      child: AnimationLimiter(
        key: ValueKey(model.product?.id),
        child: AnimationConfiguration.staggeredList(
            position: 0,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              horizontalOffset: isUpSwipe == true ? 150 : -150,
              curve: Curves.fastOutSlowIn,
              child: Opacity(
                opacity: 1,
                child: Text(
                  model.product?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 30.spMin,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildPricePageView(ProductWithDirection model) {
    double opacity = 1;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 20.h,
        left: 20.w,
        right: 10.w,
      ),
      child: AnimationLimiter(
        key: ValueKey(model.product?.id),
        child: AnimationConfiguration.staggeredList(
          position: 0,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: isUpSwipe ? 50 : -50,
            child: Opacity(
              opacity: opacity,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${model.product?.price.toString().split('.').first ?? '00'}.',
                      style: TextStyle(
                        fontSize: 32.spMin,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${model.product?.price.toString().split('.').last ?? '00'}DT',
                      style: TextStyle(
                        fontSize: 14.spMin,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get isUpSwipe =>
      widget.modelNotifier.value.swipeDirection == MoveType.up;
}

class ProductWithDirection {
  final Product? product;
  final MoveType? swipeDirection;

  ProductWithDirection({
    this.product,
    this.swipeDirection,
  });
}

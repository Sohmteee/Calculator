import 'package:app/res/res.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onTap,
    required this.child,
    this.isExpanded = false,
    this.color,
  });

  final VoidCallback? onTap;
  final String child;
  final bool isExpanded;
  final Color? color;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: widget.onTap,
      child: Container(
        height: 60.h,
        width: widget.isExpanded ? double.infinity : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              widget.child,
              style: TextStyle(
                color: widget.color,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

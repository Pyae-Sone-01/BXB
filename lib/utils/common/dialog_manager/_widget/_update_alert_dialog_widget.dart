part of '../dialog_manager.dart';

class _UpdateAlertDialog extends StatelessWidget {
  final String description;
  final String donwloadLink;
  const _UpdateAlertDialog(
      {required this.description, required this.donwloadLink});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CustomImageWidget(
            //   AppResources.assets.images.logo,
            //   width: 100,
            //   color: AppResources.colors.primary400,
            // ),
            Text(
              "Update Alert!",
              style: TextStyle(
                  fontSize: 23,
                  color: AppResources.colors.primary400,
                  fontWeight: FontWeight.bold),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(description),
            ),
            Gap(15),
            ElevatedButton(
                onPressed: () {
                  donwloadLink.openLink();
                },
                child: Text("Update Now!"))
          ],
        ),
      ),
    );
  }
}

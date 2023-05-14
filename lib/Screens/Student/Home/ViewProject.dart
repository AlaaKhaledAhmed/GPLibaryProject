import 'dart:io';
import 'package:flutter/material.dart';
import 'package:library_project/Screens/Student/Home/DawonlodeProject.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_project/Widget/AppColors.dart';

class ViewPdf extends StatefulWidget {
  final File file;
  final String fileName;
  final String link;

  const ViewPdf(
      {Key? key,
      required this.file,
      required this.fileName,
      required this.link})
      : super(key: key);
  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  int indexPag = 0;
  int pages = 0;

  PDFViewController? controller;
  @override
  Widget build(BuildContext context) {
    String pageNumber = 'ص ${indexPag + 1} - $pages  ';
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBarMain(
          title: pages < 2 ? 'المشروع' : pageNumber,
          radius: 50.r,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          action: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DownloadingDialog(
                      fileName: widget.fileName,
                      url: widget.link,
                    ),
                  );
                },
                icon: Icon(Icons.download))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: PDFView(
              filePath: widget.file.path,
              //pageFling: true,
              autoSpacing: false,
              pageSnap: false,
              onRender: (pages) => setState(() => this.pages = pages!),
              onViewCreated: (controller) =>
                  setState(() => this.controller = controller),
              onPageChanged: (indexPag, _) =>
                  setState(() => this.indexPag = indexPag!),
            ),
          ),
        ));
  }
}

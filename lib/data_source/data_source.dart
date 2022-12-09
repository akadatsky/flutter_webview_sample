class ResourceInfo {
  final String title;
  final String url;

  ResourceInfo(
      this.title,
      this.url,
      );
}

/// https://www.work.ua/jobseeker/resources/
class DataSource {
  List<ResourceInfo> get resources => [
        ResourceInfo('Статистика зарплат', 'https://work.ua/salary/'),
        ResourceInfo('Свята', 'https://work.ua/holidays/'),
        ResourceInfo('Статті', 'https://work.ua/articles/'),
        ResourceInfo('Новини ринку праці', 'https://work.ua/news/ukraine/'),
        ResourceInfo('Новини Work.ua', 'https://work.ua/news/site/'),
        ResourceInfo('Як знайти роботу', 'https://work.ua/how-to-find-a-job/'),
        ResourceInfo('Ким бути', 'https://work.ua/career-guide/'),
      ];
}

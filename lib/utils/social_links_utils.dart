final RegExp validFbRegex = RegExp(r'^.*?((facebook|fb)\.com\/(?!feed\/)\S+)');

final RegExp validInstagramRegex = RegExp(r'^.*?((instagram)\.com\/\S+)');

final RegExp validLinkedInRegex =
    RegExp(r'^.*?((linkedin)\.com\/(?!feed\/)\S+)');

class SocialLinksUtils {
  static bool verifySocialLink(String link) {
    return RegExp(r'^.*?((facebook|fb)\.com\/(?!feed\/)\S+)').hasMatch(link) ||
        RegExp(r'^.*?((instagram)\.com\/\S+)').hasMatch(link) ||
        RegExp(r'^.*?((linkedin)\.com\/(?!feed\/)\S+)').hasMatch(link);
  }

  static bool verifyFewSameSocialLink(String link, List<String> inputs) {
    var fbResults = 0;
    var instaResults = 0;
    var lIResults = 0;

    if (validFbRegex.hasMatch(link)) {
      ++fbResults;
    }
    if (validInstagramRegex.hasMatch(link)) {
      ++instaResults;
    }
    if (validLinkedInRegex.hasMatch(link)) {
      ++lIResults;
    }
    inputs.forEach((it) {
      if (validFbRegex.hasMatch(it)) {
        ++fbResults;
      }
      if (validInstagramRegex.hasMatch(it)) {
        ++instaResults;
      }
      if (validLinkedInRegex.hasMatch(it)) {
        ++lIResults;
      }
    });

    return fbResults > 2 || instaResults > 2 || lIResults > 2;
  }

  static bool verifySocialLinksMainPage(String link) {
    return RegExp(
          r'^(https:\/\/)?(www\.)?(m\.)?(facebook|fb)\.com\/?(feed\/?|.+\.php|home\.php.*|(profile\.php)?\?(?!id).*|)?$',
        ).hasMatch(link) ||
        RegExp(
          r'^(https:\/\/)?(www\.)?([a-z][a-z]\.)?(instagram)\.com\/?(\?.*)?$',
        ).hasMatch(link) ||
        RegExp(
          r'^(https:\/\/)?(www\.)?([a-z][a-z]\.)?(linkedin)\.com\/?((feed\/?)|(in\/?))?$',
        ).hasMatch(link);
  }
}

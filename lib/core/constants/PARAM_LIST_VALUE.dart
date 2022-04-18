// paramlistValues ids, so we have them centralized in case any id changes
class ParamListValue {
  static dynamic roles = {
    "WebMaster": 8,
    "ResponsableGestionnaire": 37,
    "Prospect": 4,
    "Membre": 29,
    "ResponsableMarketingAgent": 39,
    "MemberMarektingAgent": 40,
    "Responsable Service IT": 43,
    "Membre Service IT": 44,
    'Guest': 3,
    'Responsable Service Juridique': 41,
    'Membre Service Juridique': 42,
    'Responsable Service Client': 35,
    'Membre Service Client': 36,
    'Membre Gestionnaire': 38,
    'CS President': 5,
    'Coproprietary': 7
    // "Client":,
  };

  static dynamic mediaTypes = {
    'image': 14,
    'document': 15,
    'video': 16,
  };

  static dynamic iconType = {
    "textType": 27,
    "imageType": 28,
  };

  static dynamic contentStatuses = {
    'published': 1,
    'draft': 2,
  };

  static dynamic typeOfExchange = {
    'EmailAppel': 129,
    'Email': 130,
    'Appel': 131,
  };

  static dynamic emailStatus = {
    'Received': 132,
    'Sent': 133,
  };
  static dynamic typeDocument = {
    'CIN': 139,
    'Passeport': 140,
    'Titre de sejour': 141,
    'Carte resident': 142,
    'PV Légale représentant CS': 144,
    'Profile photo': 14,
  };

  static dynamic userStatus = {
    "Pending": 145,
    "Email verified": 146,
    "Rejected": 147,
    "Returned": 148,
    "Valid": 149,
  };

  static dynamic ubbleStatus = {
    "Pending": 158,
    "Rejected": 159,
    "Valid": 160,
  };

  static dynamic typeNotification = {
    "Demande Renseignement MKT Remind Me Later": 137,
  };

  static int typePVRepresentantLegalCS = 144;
  static int typeProfilePicture = 14;
  static dynamic raisonContact = {'Other': 164};
}

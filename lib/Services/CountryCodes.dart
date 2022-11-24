import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const CountryCodes = [
  {
    "id": "187",
    "enName": "SAUDI ARABIA",
    "arName": "السعودية",
    "iso": "sa",
    "phonecode": "966"
  },
  {
    "id": "1",
    "enName": "AFGHANISTAN",
    "arName": "أفغانستان",
    "iso": "af",
    "phonecode": "93"
  },
  {
    "id": "2",
    "enName": "ALBANIA",
    "arName": "ألبانيا",
    "iso": "al",
    "phonecode": "355"
  },
  {
    "id": "3",
    "enName": "ALGERIA",
    "arName": "الجزائر",
    "iso": "dz",
    "phonecode": "213"
  },
  {
    "id": "5",
    "enName": "ANDORRA",
    "arName": "أندورا",
    "iso": "ad",
    "phonecode": "376"
  },
  {
    "id": "6",
    "enName": "ANGOLA",
    "arName": "أنغولا",
    "iso": "ao",
    "phonecode": "244"
  },
  {
    "id": "9",
    "enName": "ANTIGUA AND BARBUDA",
    "arName": "أنتيغوا وباربودا",
    "iso": "ag",
    "phonecode": "1268"
  },
  {
    "id": "10",
    "enName": "ARGENTINA",
    "arName": "الأرجنتين",
    "iso": "ar",
    "phonecode": "54"
  },
  {
    "id": "11",
    "enName": "ARMENIA",
    "arName": "أرمينيا",
    "iso": "am",
    "phonecode": "374"
  },
  {
    "id": "13",
    "enName": "AUSTRALIA",
    "arName": "أستراليا",
    "iso": "au",
    "phonecode": "61"
  },
  {
    "id": "14",
    "enName": "AUSTRIA",
    "arName": "النمسا",
    "iso": "at",
    "phonecode": "43"
  },
  {
    "id": "15",
    "enName": "AZERBAIJAN",
    "arName": "أذربيجان",
    "iso": "az",
    "phonecode": "994"
  },
  {
    "id": "16",
    "enName": "BAHAMAS",
    "arName": "باهاماس",
    "iso": "bs",
    "phonecode": "1242"
  },
  {
    "id": "17",
    "enName": "BAHRAIN",
    "arName": "البحرين",
    "iso": "bh",
    "phonecode": "973"
  },
  {
    "id": "18",
    "enName": "BANGLADESH",
    "arName": "بنغلاديش",
    "iso": "bd",
    "phonecode": "880"
  },
  {
    "id": "19",
    "enName": "BARBADOS",
    "arName": "باربادوس",
    "iso": "bb",
    "phonecode": "1246"
  },
  {
    "id": "20",
    "enName": "BELARUS",
    "arName": "بيلاروس",
    "iso": "by",
    "phonecode": "375"
  },
  {
    "id": "21",
    "enName": "BELGIUM",
    "arName": "بلجيكا",
    "iso": "be",
    "phonecode": "32"
  },
  {
    "id": "22",
    "enName": "BELIZE",
    "arName": "بليز",
    "iso": "bz",
    "phonecode": "501"
  },
  {
    "id": "23",
    "enName": "BENIN",
    "arName": "بنين",
    "iso": "bj",
    "phonecode": "229"
  },
  {
    "id": "25",
    "enName": "BHUTAN",
    "arName": "بوتان",
    "iso": "bt",
    "phonecode": "975"
  },
  {
    "id": "26",
    "enName": "BOLIVIA",
    "arName": "بوليفيا",
    "iso": "bo",
    "phonecode": "591"
  },
  {
    "id": "27",
    "enName": "BOSNIA AND HERZEGOVINA",
    "arName": "البوسنة والهرسك",
    "iso": "ba",
    "phonecode": "387"
  },
  {
    "id": "28",
    "enName": "BOTSWANA",
    "arName": "بوتسوانا",
    "iso": "bw",
    "phonecode": "267"
  },
  {
    "id": "30",
    "enName": "BRAZIL",
    "arName": "البرازيل",
    "iso": "br",
    "phonecode": "55"
  },
  {
    "id": "32",
    "enName": "BRUNEI DARUSSALAM",
    "arName": "بروناي",
    "iso": "bn",
    "phonecode": "673"
  },
  {
    "id": "33",
    "enName": "BULGARIA",
    "arName": "بلغاريا",
    "iso": "bg",
    "phonecode": "359"
  },
  {
    "id": "34",
    "enName": "BURKINA FASO",
    "arName": "بوركينا فاسو",
    "iso": "bf",
    "phonecode": "226"
  },
  {
    "id": "35",
    "enName": "BURUNDI",
    "arName": "بوروندي",
    "iso": "bi",
    "phonecode": "257"
  },
  {
    "id": "36",
    "enName": "CAMBODIA",
    "arName": "كمبوديا",
    "iso": "kh",
    "phonecode": "855"
  },
  {
    "id": "37",
    "enName": "CAMEROON",
    "arName": "الكاميرون",
    "iso": "cm",
    "phonecode": "237"
  },
  {
    "id": "38",
    "enName": "CANADA",
    "arName": "كندا",
    "iso": "ca",
    "phonecode": "1"
  },
  {
    "id": "39",
    "enName": "CAPE VERDE",
    "arName": "الرأس الأخضر",
    "iso": "cv",
    "phonecode": "238"
  },
  {
    "id": "41",
    "enName": "CENTRAL AFRICAN REPUBLIC",
    "arName": "جمهورية أفريقيا الوسطى",
    "iso": "cf",
    "phonecode": "236"
  },
  {
    "id": "42",
    "enName": "CHAD",
    "arName": "تشاد",
    "iso": "td",
    "phonecode": "235"
  },
  {
    "id": "43",
    "enName": "CHILE",
    "arName": "تشيلي",
    "iso": "cl",
    "phonecode": "56"
  },
  {
    "id": "44",
    "enName": "CHINA",
    "arName": "الصين",
    "iso": "cn",
    "phonecode": "86"
  },
  {
    "id": "47",
    "enName": "COLOMBIA",
    "arName": "كولومبيا",
    "iso": "co",
    "phonecode": "57"
  },
  {
    "id": "48",
    "enName": "COMOROS",
    "arName": "جزر القمر",
    "iso": "km",
    "phonecode": "269"
  },
  {
    "id": "49",
    "enName": "CONGO",
    "arName": "جمهورية الكونغو",
    "iso": "cg",
    "phonecode": "242"
  },
  {
    "id": "50",
    "enName": "CONGO, THE DEMOCRATIC REPUBLIC OF THE",
    "arName": "جمهورية الكونغو الديمقراطية",
    "iso": "cd",
    "phonecode": "242"
  },
  {
    "id": "52",
    "enName": "COSTA RICA",
    "arName": "كوستاريكا",
    "iso": "cr",
    "phonecode": "506"
  },
  {
    "id": "53",
    "enName": "COTE D'IVOIRE",
    "arName": "ساحل العاج",
    "iso": "ci",
    "phonecode": "225"
  },
  {
    "id": "54",
    "enName": "CROATIA",
    "arName": "كرواتيا",
    "iso": "hr",
    "phonecode": "385"
  },
  {
    "id": "55",
    "enName": "CUBA",
    "arName": "كوبا",
    "iso": "cu",
    "phonecode": "53"
  },
  {
    "id": "56",
    "enName": "CYPRUS",
    "arName": "قبرص",
    "iso": "cy",
    "phonecode": "357"
  },
  {
    "id": "57",
    "enName": "CZECH REPUBLIC",
    "arName": "جمهورية التشيك",
    "iso": "cz",
    "phonecode": "420"
  },
  {
    "id": "58",
    "enName": "DENMARK",
    "arName": "الدنمارك",
    "iso": "dk",
    "phonecode": "45"
  },
  {
    "id": "59",
    "enName": "DJIBOUTI",
    "arName": "جيبوتي",
    "iso": "dj",
    "phonecode": "253"
  },
  {
    "id": "60",
    "enName": "DOMINICA",
    "arName": "دومينيكا",
    "iso": "dm",
    "phonecode": "1767"
  },
  {
    "id": "61",
    "enName": "DOMINICAN REPUBLIC",
    "arName": "جمهورية الدومينيكان",
    "iso": "do",
    "phonecode": "1809"
  },
  {
    "id": "62",
    "enName": "ECUADOR",
    "arName": "الإكوادور",
    "iso": "ec",
    "phonecode": "593"
  },
  {
    "id": "63",
    "enName": "EGYPT",
    "arName": "مصر",
    "iso": "eg",
    "phonecode": "20"
  },
  {
    "id": "64",
    "enName": "EL SALVADOR",
    "arName": "السلفادور",
    "iso": "sv",
    "phonecode": "503"
  },
  {
    "id": "65",
    "enName": "EQUATORIAL GUINEA",
    "arName": "غينيا الاستوائية",
    "iso": "gq",
    "phonecode": "240"
  },
  {
    "id": "66",
    "enName": "ERITREA",
    "arName": "إريتريا",
    "iso": "er",
    "phonecode": "291"
  },
  {
    "id": "67",
    "enName": "ESTONIA",
    "arName": "إستونيا",
    "iso": "ee",
    "phonecode": "372"
  },
  {
    "id": "68",
    "enName": "ETHIOPIA",
    "arName": "إثيوبيا",
    "iso": "et",
    "phonecode": "251"
  },
  {
    "id": "71",
    "enName": "FIJI",
    "arName": "فيجي",
    "iso": "fj",
    "phonecode": "679"
  },
  {
    "id": "72",
    "enName": "FINLAND",
    "arName": "فنلندا",
    "iso": "fi",
    "phonecode": "358"
  },
  {
    "id": "73",
    "enName": "FRANCE",
    "arName": "فرنسا",
    "iso": "fr",
    "phonecode": "33"
  },
  {
    "id": "77",
    "enName": "GABON",
    "arName": "الغابون",
    "iso": "ga",
    "phonecode": "241"
  },
  {
    "id": "78",
    "enName": "GAMBIA",
    "arName": "غامبيا",
    "iso": "gm",
    "phonecode": "220"
  },
  {
    "id": "79",
    "enName": "GEORGIA",
    "arName": "جورجيا",
    "iso": "ge",
    "phonecode": "995"
  },
  {
    "id": "80",
    "enName": "GERMANY",
    "arName": "ألمانيا",
    "iso": "de",
    "phonecode": "49"
  },
  {
    "id": "81",
    "enName": "GHANA",
    "arName": "غانا",
    "iso": "gh",
    "phonecode": "233"
  },
  {
    "id": "83",
    "enName": "GREECE",
    "arName": "اليونان",
    "iso": "gr",
    "phonecode": "30"
  },
  {
    "id": "85",
    "enName": "GRENADA",
    "arName": "غرينادا",
    "iso": "gd",
    "phonecode": "1473"
  },
  {
    "id": "88",
    "enName": "GUATEMALA",
    "arName": "غواتيمالا",
    "iso": "gt",
    "phonecode": "502"
  },
  {
    "id": "89",
    "enName": "GUINEA",
    "arName": "غينيا",
    "iso": "gn",
    "phonecode": "224"
  },
  {
    "id": "90",
    "enName": "GUINEA-BISSAU",
    "arName": "غينيا بيساو",
    "iso": "gw",
    "phonecode": "245"
  },
  {
    "id": "91",
    "enName": "GUYANA",
    "arName": "غيانا",
    "iso": "gy",
    "phonecode": "592"
  },
  {
    "id": "92",
    "enName": "HAITI",
    "arName": "هايتي",
    "iso": "ht",
    "phonecode": "509"
  },
  {
    "id": "95",
    "enName": "HONDURAS",
    "arName": "هندوراس",
    "iso": "hn",
    "phonecode": "504"
  },
  {
    "id": "97",
    "enName": "HUNGARY",
    "arName": "المجر",
    "iso": "hu",
    "phonecode": "36"
  },
  {
    "id": "98",
    "enName": "ICELAND",
    "arName": "آيسلندا",
    "iso": "is",
    "phonecode": "354"
  },
  {
    "id": "99",
    "enName": "INDIA",
    "arName": "الهند",
    "iso": "in",
    "phonecode": "91"
  },
  {
    "id": "100",
    "enName": "INDONESIA",
    "arName": "إندونيسيا",
    "iso": "id",
    "phonecode": "62"
  },
  {
    "id": "101",
    "enName": "IRAN, ISLAMIC REPUBLIC OF",
    "arName": "إيران",
    "iso": "ir",
    "phonecode": "98"
  },
  {
    "id": "102",
    "enName": "IRAQ",
    "arName": "العراق",
    "iso": "iq",
    "phonecode": "964"
  },
  {
    "id": "103",
    "enName": "IRELAND",
    "arName": "أيرلندا",
    "iso": "ie",
    "phonecode": "353"
  },
  {
    "id": "105",
    "enName": "ITALY",
    "arName": "إيطاليا",
    "iso": "it",
    "phonecode": "39"
  },
  {
    "id": "106",
    "enName": "JAMAICA",
    "arName": "جامايكا",
    "iso": "jm",
    "phonecode": "1876"
  },
  {
    "id": "107",
    "enName": "JAPAN",
    "arName": "اليابان",
    "iso": "jp",
    "phonecode": "81"
  },
  {
    "id": "108",
    "enName": "JORDAN",
    "arName": "الأردن",
    "iso": "jo",
    "phonecode": "962"
  },
  {
    "id": "109",
    "enName": "KAZAKHSTAN",
    "arName": "كازاخستان",
    "iso": "kz",
    "phonecode": "7"
  },
  {
    "id": "110",
    "enName": "KENYA",
    "arName": "كينيا",
    "iso": "ke",
    "phonecode": "254"
  },
  {
    "id": "111",
    "enName": "KIRIBATI",
    "arName": "كيريباتي",
    "iso": "ki",
    "phonecode": "686"
  },
  {
    "id": "112",
    "enName": "KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF",
    "arName": "كوريا الشمالية",
    "iso": "kp",
    "phonecode": "850"
  },
  {
    "id": "113",
    "enName": "KOREA, REPUBLIC OF",
    "arName": "كوريا الجنوبية",
    "iso": "kr",
    "phonecode": "82"
  },
  {
    "id": "114",
    "enName": "KUWAIT",
    "arName": "الكويت",
    "iso": "kw",
    "phonecode": "965"
  },
  {
    "id": "115",
    "enName": "KYRGYZSTAN",
    "arName": "قيرغيزستان",
    "iso": "kg",
    "phonecode": "996"
  },
  {
    "id": "116",
    "enName": "LAO PEOPLE'S DEMOCRATIC REPUBLIC",
    "arName": "لاوس",
    "iso": "la",
    "phonecode": "856"
  },
  {
    "id": "117",
    "enName": "LATVIA",
    "arName": "لاتفيا",
    "iso": "lv",
    "phonecode": "371"
  },
  {
    "id": "118",
    "enName": "LEBANON",
    "arName": "لبنان",
    "iso": "lb",
    "phonecode": "961"
  },
  {
    "id": "119",
    "enName": "LESOTHO",
    "arName": "ليسوتو",
    "iso": "ls",
    "phonecode": "266"
  },
  {
    "id": "120",
    "enName": "LIBERIA",
    "arName": "ليبيريا",
    "iso": "lr",
    "phonecode": "231"
  },
  {
    "id": "121",
    "enName": "LIBYAN ARAB JAMAHIRIYA",
    "arName": "ليبيا",
    "iso": "ly",
    "phonecode": "218"
  },
  {
    "id": "122",
    "enName": "LIECHTENSTEIN",
    "arName": "ليختنشتاين",
    "iso": "li",
    "phonecode": "423"
  },
  {
    "id": "123",
    "enName": "LITHUANIA",
    "arName": "ليتوانيا",
    "iso": "lt",
    "phonecode": "370"
  },
  {
    "id": "124",
    "enName": "LUXEMBOURG",
    "arName": "لوكسمبورغ",
    "iso": "lu",
    "phonecode": "352"
  },
  {
    "id": "126",
    "enName": "MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF",
    "arName": "مقدونيا",
    "iso": "mk",
    "phonecode": "389"
  },
  {
    "id": "127",
    "enName": "MADAGASCAR",
    "arName": "مدغشقر",
    "iso": "mg",
    "phonecode": "261"
  },
  {
    "id": "128",
    "enName": "MALAWI",
    "arName": "مالاوي",
    "iso": "mw",
    "phonecode": "265"
  },
  {
    "id": "129",
    "enName": "MALAYSIA",
    "arName": "ماليزيا",
    "iso": "my",
    "phonecode": "60"
  },
  {
    "id": "130",
    "enName": "MALDIVES",
    "arName": "جزر المالديف",
    "iso": "mv",
    "phonecode": "960"
  },
  {
    "id": "131",
    "enName": "MALI",
    "arName": "مالي",
    "iso": "ml",
    "phonecode": "223"
  },
  {
    "id": "132",
    "enName": "MALTA",
    "arName": "مالطا",
    "iso": "mt",
    "phonecode": "356"
  },
  {
    "id": "133",
    "enName": "MARSHALL ISLANDS",
    "arName": "جزر مارشال",
    "iso": "mh",
    "phonecode": "692"
  },
  {
    "id": "135",
    "enName": "MAURITANIA",
    "arName": "موريتانيا",
    "iso": "mr",
    "phonecode": "222"
  },
  {
    "id": "136",
    "enName": "MAURITIUS",
    "arName": "موريشيوس",
    "iso": "mu",
    "phonecode": "230"
  },
  {
    "id": "138",
    "enName": "MEXICO",
    "arName": "المكسيك",
    "iso": "mx",
    "phonecode": "52"
  },
  {
    "id": "139",
    "enName": "MICRONESIA, FEDERATED STATES OF",
    "arName": "ولايات ميكرونيسيا المتحدة",
    "iso": "fm",
    "phonecode": "691"
  },
  {
    "id": "140",
    "enName": "MOLDOVA, REPUBLIC OF",
    "arName": "مولدوفا",
    "iso": "md",
    "phonecode": "373"
  },
  {
    "id": "141",
    "enName": "MONACO",
    "arName": "موناكو",
    "iso": "mc",
    "phonecode": "377"
  },
  {
    "id": "142",
    "enName": "MONGOLIA",
    "arName": "منغوليا",
    "iso": "mn",
    "phonecode": "976"
  },
  {
    "id": "144",
    "enName": "MOROCCO",
    "arName": "المغرب",
    "iso": "ma",
    "phonecode": "212"
  },
  {
    "id": "145",
    "enName": "MOZAMBIQUE",
    "arName": "موزمبيق",
    "iso": "mz",
    "phonecode": "258"
  },
  {
    "id": "146",
    "enName": "MYANMAR",
    "arName": "ميانمار",
    "iso": "mm",
    "phonecode": "95"
  },
  {
    "id": "147",
    "enName": "NAMIBIA",
    "arName": "ناميبيا",
    "iso": "na",
    "phonecode": "264"
  },
  {
    "id": "148",
    "enName": "NAURU",
    "arName": "ناورو",
    "iso": "nr",
    "phonecode": "674"
  },
  {
    "id": "149",
    "enName": "NEPAL",
    "arName": "نيبال",
    "iso": "np",
    "phonecode": "977"
  },
  {
    "id": "150",
    "enName": "NETHERLANDS",
    "arName": "هولندا",
    "iso": "nl",
    "phonecode": "31"
  },
  {
    "id": "153",
    "enName": "NEW ZEALAND",
    "arName": "نيوزيلندا",
    "iso": "nz",
    "phonecode": "64"
  },
  {
    "id": "154",
    "enName": "NICARAGUA",
    "arName": "نيكاراغوا",
    "iso": "ni",
    "phonecode": "505"
  },
  {
    "id": "155",
    "enName": "NIGER",
    "arName": "النيجر",
    "iso": "ne",
    "phonecode": "227"
  },
  {
    "id": "156",
    "enName": "NIGERIA",
    "arName": "نيجيريا",
    "iso": "ng",
    "phonecode": "234"
  },
  {
    "id": "160",
    "enName": "NORWAY",
    "arName": "النرويج",
    "iso": "no",
    "phonecode": "47"
  },
  {
    "id": "161",
    "enName": "OMAN",
    "arName": "عمان",
    "iso": "om",
    "phonecode": "968"
  },
  {
    "id": "162",
    "enName": "PAKISTAN",
    "arName": "باكستان",
    "iso": "pk",
    "phonecode": "92"
  },
  {
    "id": "163",
    "enName": "PALAU",
    "arName": "بالاو",
    "iso": "pw",
    "phonecode": "680"
  },
  {
    "id": "165",
    "enName": "PANAMA",
    "arName": "بنما",
    "iso": "pa",
    "phonecode": "507"
  },
  {
    "id": "166",
    "enName": "PAPUA NEW GUINEA",
    "arName": "بابوا غينيا الجديدة",
    "iso": "pg",
    "phonecode": "675"
  },
  {
    "id": "167",
    "enName": "PARAGUAY",
    "arName": "باراغواي",
    "iso": "py",
    "phonecode": "595"
  },
  {
    "id": "168",
    "enName": "PERU",
    "arName": "بيرو",
    "iso": "pe",
    "phonecode": "51"
  },
  {
    "id": "169",
    "enName": "PHILIPPINES",
    "arName": "الفلبين",
    "iso": "ph",
    "phonecode": "63"
  },
  {
    "id": "171",
    "enName": "POLAND",
    "arName": "بولندا",
    "iso": "pl",
    "phonecode": "48"
  },
  {
    "id": "172",
    "enName": "PORTUGAL",
    "arName": "البرتغال",
    "iso": "pt",
    "phonecode": "351"
  },
  {
    "id": "174",
    "enName": "QATAR",
    "arName": "قطر",
    "iso": "qa",
    "phonecode": "974"
  },
  {
    "id": "176",
    "enName": "ROMANIA",
    "arName": "رومانيا",
    "iso": "ro",
    "phonecode": "40"
  },
  {
    "id": "177",
    "enName": "RUSSIAN FEDERATION",
    "arName": "روسيا",
    "iso": "ru",
    "phonecode": "70"
  },
  {
    "id": "178",
    "enName": "RWANDA",
    "arName": "رواندا",
    "iso": "rw",
    "phonecode": "250"
  },
  {
    "id": "180",
    "enName": "SAINT KITTS AND NEVIS",
    "arName": "سانت كيتس ونيفيس",
    "iso": "kn",
    "phonecode": "1869"
  },
  {
    "id": "181",
    "enName": "SAINT LUCIA",
    "arName": "سانت لوسيا",
    "iso": "lc",
    "phonecode": "1758"
  },
  {
    "id": "183",
    "enName": "SAINT VINCENT AND THE GRENADINES",
    "arName": "سانت فينسنت والغرينادين",
    "iso": "vc",
    "phonecode": "1784"
  },
  {
    "id": "184",
    "enName": "SAMOA",
    "arName": "ساموا",
    "iso": "ws",
    "phonecode": "684"
  },
  {
    "id": "185",
    "enName": "SAN MARINO",
    "arName": "سان مارينو",
    "iso": "sm",
    "phonecode": "378"
  },
  {
    "id": "186",
    "enName": "SAO TOME AND PRINCIPE",
    "arName": "ساو تومي وبرينسيب",
    "iso": "st",
    "phonecode": "239"
  },
  {
    "id": "188",
    "enName": "SENEGAL",
    "arName": "السنغال",
    "iso": "sn",
    "phonecode": "221"
  },
  {
    "id": "190",
    "enName": "SEYCHELLES",
    "arName": "سيشل",
    "iso": "sc",
    "phonecode": "248"
  },
  {
    "id": "191",
    "enName": "SIERRA LEONE",
    "arName": "سيراليون",
    "iso": "sl",
    "phonecode": "232"
  },
  {
    "id": "192",
    "enName": "SINGAPORE",
    "arName": "سنغافورة",
    "iso": "sg",
    "phonecode": "65"
  },
  {
    "id": "193",
    "enName": "SLOVAKIA",
    "arName": "سلوفاكيا",
    "iso": "sk",
    "phonecode": "421"
  },
  {
    "id": "194",
    "enName": "SLOVENIA",
    "arName": "سلوفينيا",
    "iso": "si",
    "phonecode": "386"
  },
  {
    "id": "195",
    "enName": "SOLOMON ISLANDS",
    "arName": "جزر سليمان",
    "iso": "sb",
    "phonecode": "677"
  },
  {
    "id": "196",
    "enName": "SOMALIA",
    "arName": "الصومال",
    "iso": "so",
    "phonecode": "252"
  },
  {
    "id": "197",
    "enName": "SOUTH AFRICA",
    "arName": "جنوب أفريقيا",
    "iso": "za",
    "phonecode": "27"
  },
  {
    "id": "199",
    "enName": "SPAIN",
    "arName": "إسبانيا",
    "iso": "es",
    "phonecode": "34"
  },
  {
    "id": "200",
    "enName": "SRI LANKA",
    "arName": "سريلانكا",
    "iso": "lk",
    "phonecode": "94"
  },
  {
    "id": "201",
    "enName": "SUDAN",
    "arName": "السودان",
    "iso": "sd",
    "phonecode": "249"
  },
  {
    "id": "202",
    "enName": "SURINAME",
    "arName": "سورينام",
    "iso": "sr",
    "phonecode": "597"
  },
  {
    "id": "204",
    "enName": "SWAZILAND",
    "arName": "إسواتيني",
    "iso": "sz",
    "phonecode": "268"
  },
  {
    "id": "205",
    "enName": "SWEDEN",
    "arName": "السويد",
    "iso": "se",
    "phonecode": "46"
  },
  {
    "id": "206",
    "enName": "SWITZERLAND",
    "arName": "سويسرا",
    "iso": "ch",
    "phonecode": "41"
  },
  {
    "id": "207",
    "enName": "SYRIAN ARAB REPUBLIC",
    "arName": "سوريا",
    "iso": "sy",
    "phonecode": "963"
  },
  {
    "id": "209",
    "enName": "TAJIKISTAN",
    "arName": "طاجيكستان",
    "iso": "tj",
    "phonecode": "992"
  },
  {
    "id": "210",
    "enName": "TANZANIA, UNITED REPUBLIC OF",
    "arName": "تنزانيا",
    "iso": "tz",
    "phonecode": "255"
  },
  {
    "id": "211",
    "enName": "THAILAND",
    "arName": "تايلاند",
    "iso": "th",
    "phonecode": "66"
  },
  {
    "id": "212",
    "enName": "TIMOR-LESTE",
    "arName": "تيمور الشرقية",
    "iso": "tl",
    "phonecode": "670"
  },
  {
    "id": "213",
    "enName": "TOGO",
    "arName": "توغو",
    "iso": "tg",
    "phonecode": "228"
  },
  {
    "id": "215",
    "enName": "TONGA",
    "arName": "تونغا",
    "iso": "to",
    "phonecode": "676"
  },
  {
    "id": "216",
    "enName": "TRINIDAD AND TOBAGO",
    "arName": "ترينيداد وتوباغو",
    "iso": "tt",
    "phonecode": "1868"
  },
  {
    "id": "217",
    "enName": "TUNISIA",
    "arName": "تونس",
    "iso": "tn",
    "phonecode": "216"
  },
  {
    "id": "218",
    "enName": "TURKEY",
    "arName": "تركيا",
    "iso": "tr",
    "phonecode": "90"
  },
  {
    "id": "219",
    "enName": "TURKMENISTAN",
    "arName": "تركمانستان",
    "iso": "tm",
    "phonecode": "7370"
  },
  {
    "id": "221",
    "enName": "TUVALU",
    "arName": "توفالو",
    "iso": "tv",
    "phonecode": "688"
  },
  {
    "id": "222",
    "enName": "UGANDA",
    "arName": "أوغندا",
    "iso": "ug",
    "phonecode": "256"
  },
  {
    "id": "223",
    "enName": "UKRAINE",
    "arName": "أوكرانيا",
    "iso": "ua",
    "phonecode": "380"
  },
  {
    "id": "224",
    "enName": "UNITED ARAB EMIRATES",
    "arName": "الإمارات العربية المتحدة",
    "iso": "ae",
    "phonecode": "971"
  },
  {
    "id": "225",
    "enName": "UNITED KINGDOM",
    "arName": "المملكة المتحدة",
    "iso": "gb",
    "phonecode": "44"
  },
  {
    "id": "226",
    "enName": "UNITED STATES",
    "arName": "الولايات المتحدة",
    "iso": "us",
    "phonecode": "1"
  },
  {
    "id": "228",
    "enName": "URUGUAY",
    "arName": "الأوروغواي",
    "iso": "uy",
    "phonecode": "598"
  },
  {
    "id": "229",
    "enName": "UZBEKISTAN",
    "arName": "أوزبكستان",
    "iso": "uz",
    "phonecode": "998"
  },
  {
    "id": "230",
    "enName": "VANUATU",
    "arName": "فانواتو",
    "iso": "vu",
    "phonecode": "678"
  },
  {
    "id": "231",
    "enName": "VENEZUELA",
    "arName": "فنزويلا",
    "iso": "ve",
    "phonecode": "58"
  },
  {
    "id": "232",
    "enName": "VIET NAM",
    "arName": "فيتنام",
    "iso": "vn",
    "phonecode": "84"
  },
  {
    "id": "237",
    "enName": "YEMEN",
    "arName": "اليمن",
    "iso": "ye",
    "phonecode": "967"
  },
  {
    "id": "238",
    "enName": "ZAMBIA",
    "arName": "زامبيا",
    "iso": "zm",
    "phonecode": "260"
  },
  {
    "id": "239",
    "enName": "ZIMBABWE",
    "arName": "زيمبابوي",
    "iso": "zw",
    "phonecode": "263"
  }
];

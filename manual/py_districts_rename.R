
#This script has the sole purpose to clean the names of the districts/municipalities names
#of the whole country... so then whenever I access a new dataset, I can transform them quickly
#and made them ready to merge/left_join bind, etc...


#Main convention: just have the full name of the districts, without any separation, all lower caps
# also eñes are replaced with enes ñ = n, no accentos, no points, no spaces...

#example:

# San Juan Bautista de Ñeembucú should be converted to sanjuanbautistadeneembucu

# Mayor Julio Dionisio Otaño should be mayorjuliodionisiootano

#Let's talk about mayor otano as an example for things that can go wrong: sometimes we are going to see some things like:

# Mayor J.D. Otaño... so then it looks kinda weird to translate it to mayorjuliodionisiootano... but

#I need to start somewhere.. What I think I can do is to generate a repository of different variations of the names
#for districts and have a final list of 2 lists: standarized names and FOR LATER USE: Proper/nice names like:
#Mayor Otaño or smth like that... OK....

#Ok, this script has to be of only functions I believe...

py_rename <- function(name_of_py_division){
  
  name_of_py_division = str_to_lower(name_of_py_division) #lowercase everything
  
  name_of_py_division <- str_replace_all(name_of_py_division,"\\.","")
  
  name_of_py_division <- str_replace_all(name_of_py_division,"\\,","")
    
  name_of_py_division <- gsub("[[:space:]]", "", name_of_py_division)  #get rid of spaces
  
  name_of_py_division <- str_replace(name_of_py_division,"gral","general")# risky, but maybe worth it
  # name_of_py_division <- str_replace(name_of_py_division,"dr","doctor")# Nope, it generates problems with the name "pedro"
  name_of_py_division <- str_replace(name_of_py_division,"tte","teniente")# risky, but maybe worth it
  name_of_py_division <- str_replace(name_of_py_division,"mcal","mariscal")
  name_of_py_division <- str_replace(name_of_py_division,"pte","presidente")
  name_of_py_division <- str_replace(name_of_py_division,"pdte","presidente")
  name_of_py_division <- str_replace(name_of_py_division,"cptan","capitan")
  name_of_py_division <- str_replace(name_of_py_division,"capm","capitan")
  name_of_py_division <- str_replace(name_of_py_division,"pto","puerto")
  #name_of_py_division <- str_replace(name_of_py_division,"sta","santa") #nope, generate problems with bautista
  name_of_py_division <- str_replace(name_of_py_division,"cnel","coronel")
  name_of_py_division <- str_replace(name_of_py_division,"fdo","fernando")
  
  
  
  to_plain <- function(s) {
    
    # 1 character substitutions
    espanol <- c("á", "é", "í", "ó","ú","ñ","'","â","ò","ì","�","è","à","ü","ã")
    english <- c("a", "e", "i", "o","u","n","","a","o","i","n","e","a","u","a")
    
    # Initialize the result as the input string
    s2 <- s
    
    for(i in seq_along(espanol)) 
      s2 <- gsub(espanol[i], english[i], s2, fixed = TRUE)
    s2
  }

  name_of_py_division <-  to_plain(name_of_py_division)
  #awesome, and I think I can go a little further actually and now put all the machinery of standarization
  #meaning, compile all the different names that I saw in the past and put them here with a huge CASE_WHEN !!!
  
  name_of_py_division <- tibble(row_name_of_the_tibble = name_of_py_division)
  
  name_of_py_division <- name_of_py_division %>% mutate(row_name_of_the_tibble = case_when(row_name_of_the_tibble %in% c("lavictoria(puertocasado)","delavictoria","puertocasado",
                                                                                                                         "lavictoriaexpuertocasado","pto_casado","lavictoria(expuertocasado)") ~ "lavictoria",
                                   row_name_of_the_tibble %in% c("sgtojosefelixlopez","josefelixlopez","felixlopez","sgtofelixlopex","sgtojosefelixlopez(puentezino)") ~ "sargentojosefelixlopez",
                                   row_name_of_the_tibble %in% c( "domingomdeirala","domingomarta­nezdeirala","domingomartinezde!rala","domingomartinez","dmirala") ~ "domingomartinezdeirala",
                                   row_name_of_the_tibble %in% c("mariscalfranciscosolano","franciscosolanolopez","franciscoslopez","mariscalfranciscosolanolope","mariscalfslopez","mariscalfsolanolopez",
                                                                 "mariscalfranciscoslopez","mariscalfcoslopez") ~ "mariscalfranciscosolanolopez",
                                   row_name_of_the_tibble %in% c("generalfresquin","generalfiresquin","generalfranciscoresquin","generalisidororesquin","generalfranciscoiresquin","resquin",
                                                                 "generalfranciscoisidorore","generaliresquin","generalresquin","generalfranciscolresquin","generalisidroresquin","isidororesquin") ~ "generalfranciscoisidororesquin" ,
                                   row_name_of_the_tibble %in% c("drjuanleonmallorquin","drjuanlea³nmallorqua­n","juanlmayorquin","drjuanlmallorquin") ~ "doctorjuanleonmallorquin" ,
                                   row_name_of_the_tibble %in% c("generaljosembruguez","generaljosembrugue","generalbruguez","gralbruguez","graljosemariabruguez") ~ "generaljosemariabruguez",
                                   row_name_of_the_tibble %in% c("roquealonso","marianoralonso","marianoroqalonso","mralonso") ~ "marianoroquealonso",
                                   row_name_of_the_tibble %in% c("fortinjosefalcon","puertofalcon","puertojosefalcon") ~ "josefalcon",
                                   row_name_of_the_tibble %in% c("jagustosaldivar","jaugustosaldivar","juanaugustosaldivar","julia¡naugustosalda­var",
                                                                 "joseasaldivar","julianaugustosaldivar","jasaldivar") ~ "joseaugustosaldivar",
                                   row_name_of_the_tibble %in% c("sanrgdestacruz","sanroquegonzalez","sanroquegdescruz","sanroquegdesantacruz",
                                                                 "sanroquegonzalezdesattacruz","roquegonzalezdesantacruz","roquegdesantacruz") ~ "sanroquegonzalezdesantacruz",
                                   row_name_of_the_tibble %in% c("carlosalopez","carlosantoniola³pez") ~ "carlosantoniolopez",
                                   row_name_of_the_tibble %in% c("leandrooviedo","joseloviedo") ~ "joseleandrooviedo",
                                   row_name_of_the_tibble %in% c("sanpycuamandyju","sanpedrodely","sanpedrodelycuamandyyaº","sanpedroycuamandyyu","sanpedro","sanpedrodeycuamandiyu","sanpedrodelycuamandiyu",
                                                                 "sanpedrodelykuamandiyu","sanpedrodeycuamandyy","sanpedrodeycuamandyyu","sanpedrodelycuamandyju") ~ "sanpedrodelycuamandyyu",
                                   row_name_of_the_tibble %in% c("yasycany","yacykaný","yacykany") ~ "yasykany",
                                   row_name_of_the_tibble %in% c("ygatimi","igatimi","ygatymi","villaygatim?","villaygatim-","villaygatima­","villaygatima","villaygatimö") ~ "villaygatimi",
                                   row_name_of_the_tibble %in% c("yrybucua","yryvucua","yrybycua","yrybucua¡") ~ "yrybukua",
                                   row_name_of_the_tibble %in% c("puentekyha","franciscocalvarez","franciscocaballeroalvarez","generalfranciscocaballero","fcaballeroalvarez","fcaballeroalvarez","fransicocabalvarez",
                                                                 "caballeroalvares","generalfcaballeroalvarez","generalfranciscocalvarez","generalfcalvarez",
                                                                 "franciscocaballeroa","generalfranciscocaballeroalvar","franciscocaballero","franciscocaballeroalvare") ~ "generalfranciscocaballeroalvarez",
                                   row_name_of_the_tibble %in% c("iralafernandez","teniente1manueliralafernandez","tenientemanueliralafernandez","teniente1a°manueliralafernandez",
                                                                 "teniente1°manueliralafernandez","tenienteiralafernandez","teniente1ºmanueliralafernandez",
                                                                 "teniente1°manueliralafernande","tenienteprimeromanuelirala") ~ "teniente1romanueliralafernandez",
                                   row_name_of_the_tibble == "raulaoviedo" ~ "raularseniooviedo",
                                   row_name_of_the_tibble %in% c("mayormartinez","mayorjosedmartiez","mayorjmartinez","mayorjosemartinez","myorjosedmartine",
                                                                 "mayorjosedmartinez","mayorjdejesusmartinez","municipalidadmayormartinez",
                                                                 "mayorjosedjmartinez","mayorjosejmartinez") ~ "mayorjosedejesusmartinez",
                                   row_name_of_the_tibble %in% c("generaleaquino","generalaquino","elizardoa") ~ "generalelizardoaquino",
                                   row_name_of_the_tibble == "yrybucua" ~ "yrybukua",
                                   row_name_of_the_tibble %in% c("josedomingoocampo","jdocampos") ~ "josedomingoocampos",
                                   row_name_of_the_tibble %in% c("atyra¡") ~ "atyra",
                                   row_name_of_the_tibble %in% c("generalbcaballero","generalbernarinocaballero","generalbernardinocaballer",
                                                                 "generalbernardinocaballe","bernardinocaballero","generalbernadinocaballero") ~ "generalbernardinocaballero",
                                   row_name_of_the_tibble %in% c("drraulpeã‘a","raulpena","municipalidaddrraulpena",
                                                                 "drraulpe?a","drraulpena","drraulpea‘a","drraulpeða","drraulpe¥a") ~ "doctorraulpena",
                                   row_name_of_the_tibble %in% c("itagua","itaugüa","itaugua¡")  ~ "itaugua",
                                   row_name_of_the_tibble %in% c("tayao","coloniatayao")  ~ "ri3corrales",
                                   row_name_of_the_tibble %in% c("generaljeduvigisdiaz","joseeduvigisdiaz","generaldiaz","generaljoseediaz","generaljediaz",
                                                                 "ghraljoseediaz","generaljoseeduvigjsdiaz","generaleduvigisdiaz")  ~ "generaljoseeduvigisdiaz",
                                   row_name_of_the_tibble %in% c("sanjuanbautistadelneembucu","sanjuanbautistadeneem","sanjuanbdeneembucu",
                                                                 "sanjbautistaneembucu","sanjuanbautistadeã‘eembucu","sanjuanbautistade?eembucu",
                                                                 "sanjuanbautistade¥eembucu","sanjuanbautistadea‘eembucu","sanjuanbautistadeðeembucu",
                                                                 "sjuanbneembucu") ~ "sanjuanbautistadeneembucu",
                                   row_name_of_the_tibble %in% c("municipalidadzanjapyta","sanjapyta") ~ "zanjapyta",
                                   row_name_of_the_tibble %in% c("municipalidadkarapai","karapai ","karapai") ~ "karapai",
                                   row_name_of_the_tibble %in% c("guayaybi","guajaivi","guajayvi","guajaybi") ~ "guayaibi",
                                   row_name_of_the_tibble %in% c("mayorjuliodionisioota?o","mayorota?o","mayorjuliodotano","mayorjdotano","mayorotano",
                                                                 "mayorjuliootano","mayorotaã‘o","mayotrjuliodotano","mayorjuliodionisiootaa‘o",
                                                                 "mayorjuliodionisiootano","mayorotaðo","mayorjuliodotaqo","mayorota¥o","mayorjuliodionisiootaa±") ~ "mayorjuliodionisiootano",
                                   row_name_of_the_tibble %in% c("tomasrpereira","tomasromerop","toma¡sromeropereira") ~ "tomasromeropereira",
                                   row_name_of_the_tibble == "sancarlos" ~ "sancarlosdelapa",
                                   row_name_of_the_tibble %in% c("moisesbertoni","drmoisesbertoni","moisesbertonl","doctormoisessbertoni",
                                                                 "moisesbertonl ","bertoni","moisessbertoni","drmoisessbertoni") ~ "doctormoisesbertoni",
                                   row_name_of_the_tibble %in% c("yegros","municipalidadfulgencioyegros") ~ "fulgencioyegros",
                                   row_name_of_the_tibble %in% c("generalhmorinigo","generalmorinigo") ~ "generalhiginiomorinigo",
                                   row_name_of_the_tibble %in% c("itakiry ","itakiry") ~ "itakyry",
                                   row_name_of_the_tibble %in% c("sancrjstobal","sancrista³bal")   ~ "sancristobal",
                                   row_name_of_the_tibble %in% c("sajuanbautista","sanjuanbmisiones","sanjuanbautistadelasmisiones","sanjuanbautistadelasmisione",
                                                                 "sanjuanbautistamisiones") ~ "sanjuanbautista",
                                   row_name_of_the_tibble %in% c("mauriciojtroche","mauriciojosetroche","capmjosetroche","capitanauriciojosetroche",
                                                                 "ctanmjosetroche","capitanjosetroche","cptanmauriciojosetroche","mauricio#osetroc$e") ~ "capitanmauriciojosetroche",
                                   row_name_of_the_tibble %in% c("mingaguazaº","mlngaguazu") ~ "mingaguazu",
                                   row_name_of_the_tibble == "villaoljva" ~ "villaoliva",
                                   row_name_of_the_tibble %in% c("felizperezcardozo","felixpcardozo","feuxperezcardozo","felixperezcardozoguaira")  ~ "felixperezcardozo",
                                   row_name_of_the_tibble %in% c("encarnacia³n")  ~ "encarnacion",
                                   row_name_of_the_tibble %in% c("capiata¡")  ~ "capiata",
                                   row_name_of_the_tibble %in% c("maracanµ")  ~ "maracana",
                                   row_name_of_the_tibble %in% c("capita¡nmiranda")  ~ "capitanmiranda",
                                   row_name_of_the_tibble %in% c("doctorbotrell","doctorbottrell","drbottrell","drbotrell","drbottrel") ~ "doctorbottrell",
                                   row_name_of_the_tibble %in% c("villasanisidrocuruguaty","sanisidrocuruguaty","sanidelcuruguaty","villacuruguaty","villasanisidrodecuruguaty") ~ "curuguaty",
                                   row_name_of_the_tibble %in% c("mariscaljoseestigarribia","josefelixestigarribia","mariscalestigarribia",
                                                                 "mariscaljosefestigarribia","mariscaljfelixestigarribia","doctorpedroppena","drpedroppena","pedroppena","mariscaljfestigarrib") ~ "mariscaljosefelixestigarribia",
                                   row_name_of_the_tibble %in% c("generaleugenioagaray","generalgaray",
                                                                 "eugenioagaray","generaleagaray","generalegaray") ~ "generaleugenioalejandrinogaray",
                                   row_name_of_the_tibble %in% c("yataitydelguaira") ~ "yataity",
                                   row_name_of_the_tibble %in% c("yataytydelnorte") ~ "yataitydelnorte",
                                   row_name_of_the_tibble %in% c("guazu-cua") ~ "guazucua",
                                   row_name_of_the_tibble %in% c("guarambara©") ~ "guarambare",
                                   row_name_of_the_tibble %in% c("capita¡nbado") ~ "capitanbado",
                                   row_name_of_the_tibble %in% c("yaguara³n","yaguron") ~ "yaguaron",
                                   row_name_of_the_tibble %in% c("drjuanmfrutos","juanmfrutos","juanmanuelfrutos",
                                                                 "pastoreo","drjuanmanuelfrutos","doctormanuelfrutos") ~ "doctorjuanmanuelfrutos",
                                   row_name_of_the_tibble %in% c("drjuaneulogioestigarri","dreulogiojestigarribia","drjuaneestigarribia","dreulogioestigarribia","jeulogioestigarribia","jeestigarribia",
                                                                 "joseeestigattibia","drjeulogioestigarribia","drjeestigarribia","drjeestigrarrib",
                                                                 "drjuaneulogioestigarribia","juaneulogioestigarribia","doctorjeulogioestigarribia") ~ "doctorjuaneulogioestigarribia",
                                   row_name_of_the_tibble %in% c("independencia","melgarejo","indenpencia") ~ "coloniaindependencia",
                                   row_name_of_the_tibble %in% c("mallorquin","drjlmallorquin","jlmallorquin","juanleonmallorquin", "drjuanlmallorquin") ~ "doctorjuanleonmallorquin",
                                   row_name_of_the_tibble %in% c("drceciliobaez","ceciliobaez","cecilobaez") ~ "doctorceciliobaez",
                                   row_name_of_the_tibble == "aranjal"  ~ "naranjal",
                                   row_name_of_the_tibble == "!turbe" ~ "iturbe",
                                   row_name_of_the_tibble %in% c("josedom!goocampos","josedocampos") ~ "josedomingoocampos",
                                   row_name_of_the_tibble %in% c("santarlta","starita") ~ "santarita",
                                   row_name_of_the_tibble %in% c("itacurubdelrosario","itacdelrosario","itacurubidelrosario ","itacurubidelrosario") ~ "itacurubidelrosario",
                                   row_name_of_the_tibble %in% c("ybypyta ","ybypyta") ~ "ybypyta",
                                   #row_name_of_the_tibble == "bellavistanorte"   ~ "bellavista",
                                   row_name_of_the_tibble %in% c("mbocayatydelguaira","mbocayatyguaira","mbocayaty-guaira") ~ "mbocayaty",
                                   row_name_of_the_tibble == "starosadelmbutuy" ~ "santarosadelmbutuy",
                                   row_name_of_the_tibble == "starosadelaguaray" ~ "santarosadelaguaray",
                                   row_name_of_the_tibble == "stamariadeasuncion" ~ "asuncion",
                                   row_name_of_the_tibble %in% c("itacurubidelascord","itacdelacordiller","itacdelacordillera","itacuribidelacordillera") ~ "itacurubidelacordillera",
                                   row_name_of_the_tibble %in% c("sanjnepomuceno","sanjuandenepomuceno","ssneponuceno") ~ "sanjuannepomuceno",
                                   row_name_of_the_tibble %in% c("ybyjau","ybyyahu","ybyyaù","ybyya?u","ybyyaaº") ~ "ybyyau",
                                   row_name_of_the_tibble == "quindy" ~ "quiindy",
                                   row_name_of_the_tibble %in% c("juanoleary","juaneo´leary","juaneo?leary","juaneoïleary",
                                   "juanemilioo’leary","juaneo¦leary","juanemiliooleary","jeoleary") ~ "juaneoleary",
                                   row_name_of_the_tibble %in% c("ricorrales","rl3corrales","municipalidadderi3corrales") ~ "ri3corrales",
                                   row_name_of_the_tibble %in% c("pedrojcaballero","pjcaballero") ~ "pedrojuancaballero",
                                   row_name_of_the_tibble %in% c("tebicuary-mi","tebycuarymi") ~ "tebicuarymi",
                                   row_name_of_the_tibble %in% c("ã‘umi","?umi","a‘umi","ðumi","qumi","¥umi") ~ "numi",
                                   row_name_of_the_tibble %in% c("santamariadefe","stamariadefemisiones") ~ "santamaria",
                                   row_name_of_the_tibble %in% c("ã‘acunday","?acunday","a‘acunday","aacunday","ðacunday","qacunday","¥acunday") ~ "nacunday",
                                   row_name_of_the_tibble %in% c("iruã‘a","iru?a","irua‘a","iruða","iruqa","iru¥a","irua±a") ~ "iruna",
                                   row_name_of_the_tibble %in% c("ã‘emby","?emby","a‘emby","ðemby","qemby","¥emby") ~ "nemby",
                                   row_name_of_the_tibble %in% c("yasycaã‘y","yasyka?y","yasyca?y","yasykaa‘y","yasykaðy","yasyka¥y") ~ "yasykany",
                                   row_name_of_the_tibble %in% c("ypehu","villaypehu","ypejh") ~ "ypejhu",
                                   row_name_of_the_tibble %in% c("lapalomadelespiritusanto","lapalomadelesanto","lapalomadelespa­ritusa") ~ "lapaloma",
                                   row_name_of_the_tibble == "loslaureles" ~ "laureles",
                                   row_name_of_the_tibble == "coronelmaciel" ~ "maciel",
                                   row_name_of_the_tibble == "generaljosemariadelgado" ~ "generaldelgado",
                                   row_name_of_the_tibble %in% c("starosamisiones","santarosamisiones","santarosademisiones","santarosamnes") ~ "santarosa",
                                   row_name_of_the_tibble %in% c("lasaltosdelguaira","saltosdelguaira","saltodelguaira¡") ~ "saltodelguaira",
                                   row_name_of_the_tibble %in% c("yvycui","ibycui") ~ "ybycui",
                                   row_name_of_the_tibble %in% c("mbaracayaº") ~ "mbaracayu",
                                   row_name_of_the_tibble %in% c("yvytimi","ybytymi") ~ "ybytimi",
                                   row_name_of_the_tibble %in% c("yvyya´u","yvyya?u","yvyya¦u","yvyyaïu","yvyyau") ~ "ybyyau",
                                   row_name_of_the_tibble %in% c("altovera¡") ~ "altovera",
                                   row_name_of_the_tibble %in% c("yvyrarobana","laybyrarobana","ybyrarovana¡") ~ "ybyrarobana",
                                   row_name_of_the_tibble %in% c("fernandolamora","fernadodelamora","fdelamora") ~ "fernandodelamora",
                                   row_name_of_the_tibble %in% c("ciudadleste") ~ "ciudaddeleste",
                                   row_name_of_the_tibble %in% c("mbocayatylyhaguy","mbocayatydelyuhaguy") ~ "mbocayatydelyhaguy",
                                   row_name_of_the_tibble %in% c("qyquyho") ~ "quyquyho",
                                   row_name_of_the_tibble %in% c("ypacari") ~ "ypacarai",
                                   row_name_of_the_tibble %in% c("lambara©") ~ "lambare",
                                   row_name_of_the_tibble %in% c("benjama­naceval") ~ "benjaminaceval",
                                   row_name_of_the_tibble %in% c("capitaneza","capitalmeza") ~ "capitanmeza",
                                   row_name_of_the_tibble %in% c("carapegua¡") ~ "carapegua",
                                   row_name_of_the_tibble %in% c("itapua") ~ "itapuapoty",
                                   row_name_of_the_tibble %in% c("santisimatrinidad") ~ "trinidad",
                                   row_name_of_the_tibble %in% c("bela©n") ~ "belen",
                                   row_name_of_the_tibble %in% c("puertoantequera") ~ "antequera",
                                   row_name_of_the_tibble %in% c("tacuara") ~ "tacuaras",
                                   row_name_of_the_tibble %in% c("ayola","ayolasmnes","ayolosmisiones","ayloasmnez") ~ "ayolas",
                                   row_name_of_the_tibble %in% c("sanestanilao","santani") ~ "sanestanislao",
                                   row_name_of_the_tibble %in% c("1rodemarzo","1demarzo","1ºdemarzo","1?demarzo") ~ "primerodemarzo",
                                   row_name_of_the_tibble %in% c("generalpatricioescobar") ~ "escobar",
                                   row_name_of_the_tibble %in% c("spedrodelparana","sanpedrodelparana¡") ~ "sanpedrodelparana",
                                   row_name_of_the_tibble %in% c("tabai","tavaa­") ~ "tavai",
                                   row_name_of_the_tibble %in% c("desmochado") ~ "desmochados",
                                   row_name_of_the_tibble %in% c("sanaregua","aregua¡") ~ "aregua",
                                   row_name_of_the_tibble %in% c("concepcin","concepcia³n") ~ "concepcion",
                                   row_name_of_the_tibble %in% c("san#oseobrero") ~ "sanjoseobrero",
                                   row_name_of_the_tibble %in% c("bor#a") ~ "borja",
                                   row_name_of_the_tibble %in% c("paraguara­") ~ "paraguari",
                                   row_name_of_the_tibble %in% c("yhaº") ~ "yhu",
                                   row_name_of_the_tibble %in% c("joseafassardi","#osfassardi") ~ "josefassardi",
                                   row_name_of_the_tibble %in% c("sanjdelosarroyos","san#osedelosarroyos","sanjosedelosarro") ~ "sanjosedelosarroyos",
                                   row_name_of_the_tibble %in% c("santiagomisiones") ~ "santiago",
                                   row_name_of_the_tibble %in% c("avai","abaa­") ~ "abai",
                                   row_name_of_the_tibble %in% c("dediciembre") ~ "25dediciembre",
                                   row_name_of_the_tibble %in% c("defebrero") ~ "3defebrero",
                                   row_name_of_the_tibble %in% c("sanignacioguazu","sanignaciomisiones","sanignaciomnes","sanignaciomns") ~ "sanignacio",
                                   row_name_of_the_tibble %in% c("villarosario","rosario") ~ "villadelrosario",
                                   row_name_of_the_tibble %in% c("demayo") ~ "3demayo",
                                   row_name_of_the_tibble %in% c("lacorpuschristi","corpuscristhi","corpuscrysthi") ~ "corpuschristi",
                                   row_name_of_the_tibble %in% c("capiivary","capivary","capiivari","capivari") ~ "capiibary",
                                   row_name_of_the_tibble %in% c("coloniapirapo") ~ "pirapo",
                                   row_name_of_the_tibble %in% c("colonsimonbolivar") ~ "simonbolivar",
                                   row_name_of_the_tibble %in% c("pasoyovai") ~ "pasoyobai",
                                   row_name_of_the_tibble %in% c("pinasco") ~ "puertopinasco",
                                   row_name_of_the_tibble %in% c("sanrafaeldelparan","srafaeldelparana") ~ "sanrafaeldelparana",
                                   row_name_of_the_tibble %in% c("starosadelmonday") ~ "santarosadelmonday",
                                   row_name_of_the_tibble %in% c("yavevyry","yabebyryi") ~ "yabebyry",
                                   row_name_of_the_tibble %in% c("ybyrarovana") ~ "ybyrarobana",
                                   row_name_of_the_tibble %in% c("fteolimpo") ~ "fuerteolimpo",
                                   row_name_of_the_tibble %in% c("sanjuandeparana") ~ "sanjuandelparana",
                                   row_name_of_the_tibble %in% c("cedrales") ~ "loscedrales",
                                   row_name_of_the_tibble %in% c("nueva_germania") ~ "nuevagermania",
                                   row_name_of_the_tibble %in% c("liberasion","cruceliberacion") ~ "liberacion",
                                   row_name_of_the_tibble %in% c("sanber","sanbernandino") ~ "sanbernardino",
                                   row_name_of_the_tibble %in% c("coloniamariaantonia") ~ "mariaantonia",
                                   row_name_of_the_tibble %in% c("nvaesperanza") ~ "nuevaesperanza",
                                   row_name_of_the_tibble %in% c("neuland","boquera“n") ~ "boqueron",
                                   row_name_of_the_tibble %in% c("mayorpablolagerenza","baha­anegra","mayorplagerenza") ~ "bahianegra",
                                   row_name_of_the_tibble %in% c("emboscada(caazapa)") ~ "buenavista",
                                   row_name_of_the_tibble %in% c("pozocolorado") ~ "villahayes",
                                   row_name_of_the_tibble %in% c("vallemi") ~ "sanlazaro",
                                   row_name_of_the_tibble %in% c("sancosme") ~ "sancosmeydamian",
                                   row_name_of_the_tibble %in% c("fernheim","fernhein","colfernheim","coloniafernheim") ~ "filadelfia",
                                   row_name_of_the_tibble %in% c("sanloenzo") ~ "sanlorenzo",
                                   row_name_of_the_tibble %in% c("katueta©") ~ "katuete",
                                   row_name_of_the_tibble %in% c("coloniablasgaray","coldrblasagaray") ~ "coroneloviedo",
                                   row_name_of_the_tibble %in% c("arroyoyesterocordillera") ~ "arroyosyesteros",
                                   row_name_of_the_tibble %in% c("caacude") ~ "caacupe",
                                   row_name_of_the_tibble %in% c("honhenau") ~ "hohenau",
                                   row_name_of_the_tibble %in% c("sanpatriciomisiones") ~ "sanpatricio",
                                   row_name_of_the_tibble %in% c("chaco-i","chacoi") ~ "nuevaasuncion",
                                   row_name_of_the_tibble %in% c("azote´y") ~ "azotey",
                                   TRUE ~ row_name_of_the_tibble))  
  

  #very interestingly, some districts sometimes show a space, like "itacurubidelrosario "... BUT ACTUALLY IT'S NOT A SPACE, because it's not being replaced
  # so the best I got is str_detect:
  
    
name_of_py_division <- name_of_py_division %>% mutate(row_name_of_the_tibble = ifelse(str_detect(row_name_of_the_tibble,"itacurubidelrosario"),"itacurubidelrosario",
                                                                                      ifelse(str_detect(row_name_of_the_tibble,"ybypyta"),"ybypyta",
                                                                                             ifelse(str_detect(row_name_of_the_tibble,"karapai"),"karapai",
                                                                                                    ifelse(str_detect(row_name_of_the_tibble,"sanroquegdescruz"),"sanroquegonzalezdesantacruz",row_name_of_the_tibble)))))

#again, so it's not that long:
name_of_py_division <- name_of_py_division %>% mutate(row_name_of_the_tibble = ifelse(str_detect(row_name_of_the_tibble,"pedrojcaballero"),"pedrojuancaballero",
                                                                                      ifelse(str_detect(row_name_of_the_tibble,"tebicuary-mi"),"tebicuarymi",
                                                                                             ifelse(str_detect(row_name_of_the_tibble,"sanroquegonzalez"),"sanroquegonzalezdesantacruz",row_name_of_the_tibble))))
                                                                                      




name_of_py_division[[1]]



  
}



#

#just to try in case something goes wrong:

# load("02_inter_data/transfers_2005_2020.RData")                       
# 
# rm(list=ls()[! ls() %in% c("transfers","py_rename")])
# 
# py_rename(transfers$municipality)






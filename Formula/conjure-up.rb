class ConjureUp < Formula
  include Language::Python::Virtualenv

  desc "Big software deployments so easy it's almost magical"
  homepage "https://conjure-up.io/"
  url "https://github.com/conjure-up/conjure-up/archive/2.5.9.tar.gz"
  sha256 "f474a7419fb0f948ea1cb16c14e229002a67339187b0a9af3e093f97e5ff309a"

  bottle do
    cellar :any
    sha256 "380d99c914ba7af0ad83f5f4656bfb00df04a2b16967c6c83a27f29ffe9e1303" => :high_sierra
    sha256 "f5c6117c1eedab7dd97275c8474b68d4835efa79b6c81cd95f71ccf4f76dbcb3" => :sierra
    sha256 "8044199cdbb0f501c89d058606983476ff56f27947e7c940a762ed3e64f9a2e2" => :el_capitan
  end

  depends_on "libyaml"
  depends_on "juju"
  depends_on "juju-wait"
  depends_on "jq"
  depends_on "redis"
  depends_on "awscli"
  depends_on "pwgen"
  depends_on "python"

  # list generated from the 'requirements.txt' file in the repository root
  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/28/51/913ed4312b63b0a1b6cad5a761b2c163eb20e353c7a3f19f08e04e8675e5/aiofiles-0.3.1.tar.gz"
    sha256 "6c4936cea65175277183553dbc27d08b286a24ae5bd86f44fbe485dfcf77a14a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "env" do
    url "https://github.com/battlemidget/env/archive/1.0.0.tar.gz"
    sha256 "a26b5c973df792ecfc1fc6b18cf696ccaf4c02c918b2878e81c6d495debaa340"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/90/61/f820ff0076a2599dd39406dcb858ecb239438c02ce706c8e91131ab9c7f1/Jinja2-2.9.6.tar.gz"
    sha256 "ddaa01a212cd6d641401cb01b605f4a4d9f37bfc93043d7f760ec70fb99ff9ff"
  end

  resource "juju" do
    url "https://files.pythonhosted.org/packages/c7/c0/a315341dc251a9f2e9dfe32a8b9f1667a15c80be8e1396fdd35e6617b4c9/juju-0.9.0.tar.gz"
    sha256 "8726a58d5d68c49a2d3589566db33b8686cd85779e09739c2db03fd70e72f185"
  end

  resource "juju-wait" do
    url "https://files.pythonhosted.org/packages/e4/34/a40b2df17343f75b6befd814b031f9fd37d61ffc309bd711fdbdb2c01eae/juju-wait-2.6.3.tar.gz"
    sha256 "52228937c6feffaa888aa286f40ce7601258ddc3a71264d466b3b809d9242c02"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/fe/6c/a70cd143c77c3a5d6935e6b9e46261e8cab4db7911691650d0bbde8a1a78/jujubundlelib-0.5.6.tar.gz"
    sha256 "80e4fbc2b8593082f57de03703df8c5ba69ed1cf73519d499f5d49c51ec91949"
  end

  resource "kv" do
    url "https://files.pythonhosted.org/packages/c7/02/69ad28c7669bb1cebc0ca1bb92eaf07f6b3b67c4f79cf1dcc5082f18d7a4/kv-0.3.tar.gz"
    sha256 "d40755e7358e2b2a624feb9e442b06168b04cf14abf4d7aa749725dfbc5034e5"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/38/27/a3d58ded98c6fb926a01ec45c55095ade186a0a366663dd033e0a296d17a/macaroonbakery-1.1.3.tar.gz"
    sha256 "6b5a009dd6f5605f97feaeb8e9807767f8a5de54455c2c6aaa0e918faca04a13"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "melddict" do
    url "https://files.pythonhosted.org/packages/89/99/c2dd9897264764544cb02de5fe0ffc277c091e973908b0894abe8900be7a/melddict-1.0.1.tar.gz"
    sha256 "70ad91f4a7fb7ee32498e828604fe10c6ceb68a5779ca9d41e5469a6c24826ea"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/df/5f/3f4aae7b28db87ddef18afed3b71921e531ca288dc604eb981e9ec9f8853/oauthlib-2.1.0.tar.gz"
    sha256 "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/ab/d1/44d8235bac6fca2480f256a47630aa759638f3d6ad4d3ebe8ec0ae38409d/progressbar2-3.20.0.tar.gz"
    sha256 "a16d34da27bfa9800605f1de3342138e102797a4b8198864c8822e94caa0e5f7"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/73/73/4f133a31d67b27431fe4b9cc5e2f74d0644bce0327a743093f3cc27864ce/protobuf-3.5.2.post1.tar.gz"
    sha256 "3b60685732bd0cbdc802dfcb6071efbcf5d927ce3127c13c33ea1a8efae3aa76"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/57/93/47a2e3befaf194ccc3d05ffbcba2cdcdd22a231100ef7e4cf63f085c900b/psutil-5.2.2.tar.gz"
    sha256 "44746540c0fab5b95401520d29eb9ffe84b3b4a235bd1d1971cbe36e1f38dd13"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/7a/8a/78e04792f04da5f3780058f8cfc35ff9eb74080faffbf321c58e6d34d089/pyRFC3339-1.0.tar.gz"
    sha256 "8dfbc6c458b8daba1c0f3620a8c78008b323a268b27b7359e92a4ae41325f535"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/30/95/d01fbd09ced38a16b7357a1d6cefe1327b9273885bffd6371cbec3e23af7/python-utils-2.3.0.tar.gz"
    sha256 "34aaf26b39b0b86628008f2ae0ac001b30e7986a8d303b61e1357dfcdad4f6d3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/10/76/52efda4ef98e7544321fd8d5d512e11739c1df18b0649551aeccfb1c8376/pytz-2018.4.tar.gz"
    sha256 "c06425302f2cf668f1bba7a0a03f3c1d34d4ebeef2c72003da308b3947c7f749"
  end

  resource "pyvmomi" do
    url "https://files.pythonhosted.org/packages/95/82/40f8c37a4c5264a2d581c24eb5f191cbdfe7f574d4013180edc84bbbf401/pyvmomi-6.5.0.2017.5-1.tar.gz"
    sha256 "c28292594281901e894c39a0c06b4126a9c019b3d804c47fb116472299dbb42d"
  end

  resource "PyYAML" do
    url "https://github.com/yaml/pyyaml/archive/4.2b2.tar.gz"
    sha256 "2d3ccbb9705eceaf36e495cfaba30277a59aa3f0a5e3c8cfffe760d89625e3d2"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/8f/80/e8d734244fd377fd7d65275b27252642512ccabe7850105922116340a37b/raven-6.9.0.tar.gz"
    sha256 "3fd787d19ebb49919268f06f19310e8112d619ef364f7989246fc8753d469888"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/d8/97/39aa189a8392522cc24f14f392955cbeac48e2818d776241c37eb6d0eb3c/sh-1.12.13.tar.gz"
    sha256 "979928ca113cade663bb1a0ff710e3eb9147596cf28a7ee4c04f9d85804f7b9f"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "theblues" do
    url "https://files.pythonhosted.org/packages/ab/09/21a4718cb6f06573153de35af742e4c251ca9b628c9001d06f6ed4b2cae5/theblues-0.3.8.tar.gz"
    sha256 "649f4013d3b9024f7990a7e0b42aed2196daea64a7c8501dde4f1f57ab8aa031"
  end

  resource "ubuntui" do
    url "https://files.pythonhosted.org/packages/e8/18/a8cf8f69de1b5bfc135bec5f46a14832e3f9eae3abf7b7978602dc49ed4b/ubuntui-0.1.9.tar.gz"
    sha256 "7249c2bfbdfe5bc4f86ac7a94fe606064f8f068f1436de35cca71b6cd6f57c78"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "websockets" do
    url "https://github.com/battlemidget/websockets/archive/5.0.1_1.tar.gz"
    sha256 "0d3b8bb2ae266831695b1d157830fea42409628c48c75b9956f74d4b1a6815a1"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/f3/ec/bb6b384b5134fd881b91b6aa3a88ccddaad0103857760711a5ab8c799358/bcrypt-3.1.4.tar.gz"
    sha256 "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/29/65/83181630befb17cd1370a6abb9a87957947a43c2332216e5975353f61d64/paramiko-2.4.1.tar.gz"
    sha256 "33e36775a6c71790ba7692a73f948b329cf9295a72b0102144b031114bd2a4f3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/0d/33/3466a3210321a02040e3ab2cd1ffc6f44664301a5d650a7e44be1dc341f2/pyasn1-0.4.3.tar.gz"
    sha256 "fb81622d8f3509f0026b0683fe90fea27be7284d3826a5f2edf97f69151ab0fc"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f/PyNaCl-1.2.1.tar.gz"
    sha256 "e0d38fa0a75f65f556fb912f2c6790d1fa29b7dd27a1d9cc5591b281321eaaa9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("cffi") # needs to be installed prior to bcrypt
    res = resources.map(&:name).to_set - ["cffi"]

    res.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
    bin.install_symlink "#{libexec}/bin/kv-cli"
  end

  test do
    assert_match "No spells found, syncing from registry, please wait", shell_output("#{bin}/conjure-up openstack-base metal --show-env")
    assert_predicate testpath/".cache/conjure-up-spells/spells-index.yaml", :exist?
  end
end

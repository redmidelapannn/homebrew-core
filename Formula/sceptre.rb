class Sceptre < Formula
  include Language::Python::Virtualenv

  desc "Build better AWS infrastructure"
  homepage "https://sceptre.cloudreach.com"
  url "https://github.com/cloudreach/sceptre/archive/v1.4.2.tar.gz"
  sha256 "0253ef680c1fe2ff589851f979fbcd28f81dd437cdbe9047ec7d3daac6600bf4"

  bottle do
    cellar :any_skip_relocation
    sha256 "d21e3624daa400166638d25509bb197114e4eb71c8f127ebec4c8b0bf91ebc06" => :mojave
    sha256 "ee02b85ef2aa9159478d9b1882cc75fbe30ed92b11229a111b6ac8a051ce18a9" => :high_sierra
    sha256 "ea0c72fdcb3be72af0dca27aef8b3d3a56ba31be463a93b10660cc84aadc59cb" => :sierra
  end

  depends_on "python"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/18/89/fb6dec1de25c1e446bc11da7d43dab967d8b948bda734140a6b3fb7dcc4a/boto3-1.9.42.tar.gz"
    sha256 "02e5c1b85a8b22a92f612daf2d1eea305818076b24ce02878b85e92d9ae0082e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/80/ac/518d1fa4b0ec896cc564742e5ce4e4b4d8ce1f8d3f9b6bb29409d1db97ca/botocore-1.12.42.tar.gz"
    sha256 "0e495bcf2e474b82da7938b35ad2f71e28384c246b47ca131779f736621da504"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/55/d5/c35bd3e63757ac767105f8695b055581d8b8dd8c22fef020ebefa2a3725d/colorama-0.4.0.zip"
    sha256 "c9b54bebe91a6a803e0772c8561d53f2926bfeb17cd141fbabcb08424086595c"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/ac/7e/1b4c2e05809a4414ebce0892fe1e32c14ace86ca7d50c70f00979ca9b3a3/MarkupSafe-1.1.0.tar.gz"
    sha256 "4e97332c9ce444b0c2c38dd22ddc61c743eb208d916e4265a2a3b575bdccb1d3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/cf/50/1f10d2626df0aa97ce6b62cf6ebe14f605f4e101234f7748b8da4138a8ed/packaging-18.0.tar.gz"
    sha256 "0886227f54515e592aaa2e5a553332c73962917f2831f1b0f9b9f4380a4b9807"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d0/09/3e6a5eeb6e04467b737d55f8bba15247ac0876f98fae659e58cd744430c6/pyparsing-2.3.0.tar.gz"
    sha256 "f353aab21fd474459d97b709e527b5571314ee5f067441dc9f88e33eecd96592"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"
    sha256 "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9a/66/c6a5ae4dbbaf253bd662921b805e4972451a6d214d0dc9fb3300cb642320/s3transfer-0.1.13.tar.gz"
    sha256 "90dc18e028989c609146e241ea153250be451e05ecc0c2832565231dacdf59c1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"sceptre", "--help"
  end
end

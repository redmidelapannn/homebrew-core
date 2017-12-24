class Beets < Formula
  desc "music library manager and MusicBrainz tagger"
  homepage "http://beets.io/"
  url "https://github.com/beetbox/beets/releases/download/v1.4.6/beets-1.4.6.tar.gz"
  sha256 "62079b2338799a64e7816096c5fae3b8909fb139e4d481ec3255336e67765b50"

  depends_on :python3

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/61/cb/df5b1ed5276d758684b245ecde990b05ea7470d4fa9530deb86a24cf723b/mutagen-1.39.tar.gz"
    sha256 "9da92566458ffe5618ffd26167abaa8fd81f02a7397b8734ec14dfe14e8a19e4"
  end

  resource "munkres" do
    url "https://github.com/bmc/munkres/archive/release-1.0.12.tar.gz"
    sha256 "70b3b32b4fed3b354e5c42e4d1273880a33a13ab8c108a4247140eb661767a0b"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/0e/26/6a4295c494e381d56bba986893382b5dd5e82e2643fc72e4e49b6c99ce15/Unidecode-0.04.21.tar.gz"
    sha256 "280a6ab88e1f2eb5af79edff450021a0d3f0448952847cd79677e55e58bad051"
  end

  resource "musicbrainzngs" do
    url "https://files.pythonhosted.org/packages/63/cc/67ad422295750e2b9ee57c27370dc85d5b85af2454afe7077df6b93d5938/musicbrainzngs-0.6.tar.gz"
    sha256 "28ef261a421dffde0a25281dab1ab214e1b407eec568cd05a53e73256f56adb5"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "jellyfish" do
    url "https://files.pythonhosted.org/packages/94/48/ddb1458d966f0a84e472d059d87a9d1527df7768a725132fc1d810728386/jellyfish-0.5.6.tar.gz"
    sha256 "887a9a49d0caee913a883c3e7eb185f6260ebe2137562365be422d1316bd39c9"
  end

  include Language::Python::Virtualenv
  def install
    venv = virtualenv_create(libexec, "python3")

    venv.pip_install resources
    venv.pip_install_and_link buildpath
  end

  test do
    system "true"
  end
end

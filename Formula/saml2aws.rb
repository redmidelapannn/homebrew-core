class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws/archive/v1.8.4.tar.gz"
  sha256 "3561a58006a27e4e166e3798a2c38b5b4c746426e9a760e4fdb44cfe654a5098"

  bottle do
    cellar :any_skip_relocation
    sha256 "0954962ee462aa2a20a5b2cca3a0143f8e8e651d0e0aa932f3d463f9d624b331" => :high_sierra
    sha256 "dd35ce617cd3fc76889305c09512df87133b78f3ae3b308c258ad184fbfe3b50" => :sierra
    sha256 "7e272366b968107e2d93bc68a4eccf5fa9ce790a006014006eee940367f3ce5e" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/versent/saml2aws"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"saml2aws", "./cmd/saml2aws"
    end
  end

  test do
    system bin/"saml2aws", "--version"
  end
end

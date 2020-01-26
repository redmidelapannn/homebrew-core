class Rnp < Formula
  desc "OpenPGP tools for encrypting, decrypting, signing, and verifying files"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp.git", :tag => "v0.13.1"
  head "https://github.com/rnpgp/rnp.git"

  bottle do
    cellar :any
    sha256 "8bb68513c2e5668617d87dafd11ab6dc0282ab9310b08cb94cab06442500dc62" => :catalina
    sha256 "c76fd6326ba712abc9be79144842c27a54087503249281b2150ef8278edc56a1" => :mojave
    sha256 "809727d23a59d725928f07388b2d9ec491c49a5aaf8654b449219773fb38ea8a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "botan"
  depends_on "json-c"

  def install
    botan = Formula["botan"]
    jsonc = Formula["json-c"]

    tag = `git describe`
    ohai "Building tag #{tag}"
    # only required to set when can't be determined automatically
    # version tag

    mkdir "build" do
      system(
        "cmake",
        "-DBUILD_SHARED_LIBS=ON",
        "-DBUILD_TESTING=OFF",
        "-DCMAKE_INSTALL_PREFIX=#{prefix}",
        "-DCMAKE_PREFIX_PATH=#{botan.prefix};#{jsonc.prefix}",
        *std_cmake_args,
        "..",
      )
      system "make", "install"
    end
  end

  test do
    system "rnp", "--version"
  end
end

class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.12.0.tar.gz"
  sha256 "e13d299a320dcceb6abf000edc20ef87545e1a83c45585e8ed59932cf72042f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "042645de46ee6a566fa5e75080e60678844858a838ca4394956e45fdf6a4ef79" => :mojave
    sha256 "eac75a4683af68b7d370d775bf317f7afd4e347df9fe0b0810b9a72da10b1acb" => :high_sierra
    sha256 "051425a52e1dd6c8f9fa46fb22ca5d4a4ab3e55870df5b6bf6149d9172c427b1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end

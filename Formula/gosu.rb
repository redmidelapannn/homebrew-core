class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.11.tar.gz"
  sha256 "78b307b67a77941c065f171f473d7395a9b9f9b777ceb6f0c7434875b162e55d"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1dde9823ef94785986e5799d03cf5e930bc84d415a120de549342a7dafd0f33c" => :mojave
    sha256 "1d99fb33eea6642e6be7d5576bb8edbee92df1ee31175efebc2179b1634e402e" => :high_sierra
    sha256 "87dbc89c4abf4eaf193e78ee065d673fc3c0e6c45c887bbd148ee614aa0055ee" => :sierra
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  skip_clean "libexec/ext"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end

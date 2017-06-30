class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.6.1.tar.gz"
  sha256 "8082040cd8c3b93c0e4fc72f2799990c72fdcf21c2b5ecdae6611482a14f1a04"
  head "https://github.com/capnproto/capnproto.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fe98e9327661a576eda9a07edd14814c0bda24cd4c274f1d75f87e10ce9559d4" => :sierra
    sha256 "dc94edf74455ee84f9285e6538e729c07fb2ed6ede09a5e099960ddc7b780645" => :el_capitan
    sha256 "7b98adf2c02186fe2dba53ab16489489e8f88720a7cb4173b7cdf47f12c40a3d" => :yosemite
  end

  needs :cxx11
  depends_on "cmake" => :build

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write Utils.popen_read("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end

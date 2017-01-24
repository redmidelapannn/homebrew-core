class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/17.01/eiffelstudio-17.01.9.9700.tar"
  sha256 "610344e8e4bbb4b8ccedc22e57b6ffa6b8fd7b9ffee05edad15fc1aa2b1259a1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2b2130718a48b479bd7df462e771ee98c33c487ad73ca7058d29b6b89ccc47ad" => :sierra
    sha256 "994b6f556006e4406ba623a9e10cc6e2d7dbe9a3bcb88152e0c2e347a0514a50" => :el_capitan
    sha256 "9583d71d48f8f99d9710a7824d572b2c0c364ce5c769499eb30e740b39d63cfe" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+" => "build-from-source"

  def ise_platform
    if Hardware::CPU.ppc?
      "macosx-ppc"
    elsif MacOS.prefer_64_bit?
      "macosx-x86-64"
    else
      "macosx-x86"
    end
  end

  def install
    system "./compile_exes", ise_platform
    system "./make_images", ise_platform
    prefix.install Dir["Eiffel_17.01/*"]
    bin.mkpath
    env = { :ISE_EIFFEL => prefix, :ISE_PLATFORM => ise_platform }
    (bin/"ec").write_env_script(prefix/"studio/spec/#{ise_platform}/bin/ec", env)
    (bin/"ecb").write_env_script(prefix/"studio/spec/#{ise_platform}/bin/ecb", env)
    (bin/"estudio").write_env_script(prefix/"studio/spec/#{ise_platform}/bin/estudio", env)
    (bin/"finish_freezing").write_env_script(prefix/"studio/spec/#{ise_platform}/bin/finish_freezing", env)
    (bin/"compile_all").write_env_script(prefix/"tools/spec/#{ise_platform}/bin/compile_all", env)
    (bin/"iron").write_env_script(prefix/"tools/spec/#{ise_platform}/bin/iron", env)
    (bin/"syntax_updater").write_env_script(prefix/"tools/spec/#{ise_platform}/bin/syntax_updater", env)
    (bin/"vision2_demo").write_env_script(prefix/"vision2_demo/spec/#{ise_platform}/bin/vision2_demo", env)
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system prefix/"studio/spec/#{ise_platform}/bin/ec", "-version"
  end
end

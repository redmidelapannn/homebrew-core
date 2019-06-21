class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  head "https://github.com/mesonbuild/meson.git"

  stable do
    url "https://github.com/mesonbuild/meson/releases/download/0.50.1/meson-0.50.1.tar.gz"
    sha256 "f68f56d60c80a77df8fc08fa1016bc5831605d4717b622c96212573271e14ecc"

    # Fixes support for Xcode 11.
    # Backported from https://github.com/mesonbuild/meson/commit/b28e76f6bf6898a7de01f5dd103d5ad7c54bea45
    # Should be in the next release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bd45b828dc74b33b35a89dc02dd1f556064d227f/meson/xcode_11.patch"
      sha256 "7b03f81036478d234d94aa8731d7248007408e56917b07d083f1c4db9bb48c8b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "85d31d2069c0b393e381259407d3393f313af8eb3f4496a4c17b723d4ff5badc" => :mojave
    sha256 "85d31d2069c0b393e381259407d3393f313af8eb3f4496a4c17b723d4ff5badc" => :high_sierra
    sha256 "c7dc6396ece799e1d0100a857565d69b8425532cb35b995a240bb672661c1dbd" => :sierra
  end

  depends_on "ninja"
  depends_on "python"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end

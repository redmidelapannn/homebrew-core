# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
  version "5.8.48"
  head "https://chromium.googlesource.com/chromium/tools/depot_tools.git"

  bottle do
    cellar :any
    sha256 "8a9ab5d7d0250dfae8083436c6db658fc0d69382aa8655708946588784c7b207" => :el_capitan
  end

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  # depot_tools/GN require Python 2.7+
  depends_on :python => :build

  needs :cxx11

  def install
    (buildpath/"depot_tools").install buildpath.children - [buildpath/".brew_home"]
    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.prepend_path "PATH", buildpath/"depot_tools"

    system "gclient", "root"
    system "gclient", "config", "--spec", <<-EOS.undent
      solutions = [
        {
          "url": "https://chromium.googlesource.com/v8/v8.git",
          "managed": False,
          "name": "v8",
          "deps_file": "DEPS",
          "custom_deps": {},
        },
      ]
      target_os = [ "mac" ]
      target_os_only = True
    EOS

    cache_location = ENV["CACHE_DEPS"]
    no_sync = ENV["NO_SYNC"]

    if cache_location and File.directory?(cache_location)
      system "cp", "-R", cache_location, "v8"
    else
      system "gclient", "sync", "-vvv", "-j #{Hardware::CPU.cores}", "-r", "#{version}" unless no_sync

      if cache_location and !File.directory?(cache_location)
        system "cp", "-R", "v8", cache_location
      end
    end

    cd "v8" do
      arch = MacOS.prefer_64_bit? ? "x64" : "x86"
      output_name = "#{arch}.release"
      output_path = "out.gn/#{output_name}"

      # Configure build
      gn_args = {
          is_debug: false,
          is_component_build: true,
          v8_use_external_startup_data: false
      }

      system "gn gen #{output_path} --args=\"#{gn_args.map { |k, v| "#{k}=#{v}" }.join(' ')}\""
      system "ninja", "-j #{Hardware::CPU.cores}", "-v", "-C", output_path, "d8"

      include.install Dir["include/*"]

      cd output_path do
        lib.install Dir["lib*"]
        bin.install "d8" => "v8"
      end
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end

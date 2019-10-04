class ElixirLs < Formula
  desc "Language Server Protocol implementation for Elixir"
  homepage "https://github.com/JakeBecker/elixir-ls"
  url "https://github.com/JakeBecker/elixir-ls/archive/v0.2.25.tar.gz"
  sha256 "48aef4a0e795627962bde7e9c5a4fd201f92ef816fc823738d6a1702ee911ee0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec67ebfab9c451ed5a7e7d893b387192fe6ce0a2a83b6dc1862cfeda88884d20" => :catalina
    sha256 "70931855729a5f6ac97c034c2842c5c8e16991ffd3690e26dda34b9624e58a0a" => :mojave
    sha256 "524f479d9d831365dce6457cc682cf4839e7afdfaf173af9b115d14be3778022" => :high_sierra
  end

  depends_on "elixir"

  def install
    # Ensure Hex and Rebar3 are installed
    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"

    system "mix", "deps.get"
    system "mix", "compile"

    system "mix", "elixir_ls.release", "-o", prefix

    # Fix the launcher script
    # it depends on being in the same directory as .ez files
    bin.mkpath
    bin.install_symlink(
      prefix/"language_server.sh" => "elixir-language-server",
      prefix/"debugger.sh"        => "elixir-debugger",
    )
  end

  test do
    begin
      io = IO.popen("#{bin}/elixir-language-server", "r+")
      io.write("\n")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)

      assert_match "Started ElixirLS", io.read
    end

    begin
      io = IO.popen("#{bin}/elixir-debugger", "r+")
      io.write("\n")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)

      assert_match "Started ElixirLS debugger", io.read
    end
  end
end

# frozen_string_literal: true

# 管理画面のナビゲーション項目のテストヘルパー
class AdminNavItemTestHelper
  # 指定されたナビゲーション項目のみがハイライトされていることを確認する
  # @param [ActionDispatch::IntegrationTest] test テスト
  # @param [Symbol, String] key ナビゲーション項目のキー
  # @return [void]
  def self.assert_highlighted(test, key)
    new(test, key).assert_highlighted
  end

  # テストヘルパーを初期化する
  # @param [ActionDispatch::IntegrationTest] test テスト
  # @param [Symbol, String] key ナビゲーション項目のキー
  def initialize(test, key)
    @test = test
    @key = key
  end

  # 指定されたナビゲーション項目のみがハイライトされていることを確認する
  # @return [void]
  def assert_highlighted
    @test.assert_select("##{@key}.active")
    @test.assert_select('#admin_nav > li.active', 1)
  end
end

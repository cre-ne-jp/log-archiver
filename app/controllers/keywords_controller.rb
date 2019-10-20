class KeywordsController < ApplicationController
  def index
    relationships = PrivmsgKeywordRelationship.arel_table
    keywords = Keyword.arel_table

    privmsg_counts = relationships
      .group(:keyword_id)
      .project(:keyword_id, Arel.sql('COUNT(*) AS privmsg_count'))
      .as('privmsg_counts')
    join_cond = keywords
      .join(privmsg_counts, Arel::Nodes::InnerJoin)
      .on(keywords[:id].eq(privmsg_counts[:keyword_id]))
      .join_sources

    page_i = params[:page].to_i
    page = page_i >= 1 ? page_i : 1
    @keyword_privmsg_counts = Keyword
      .joins(join_cond)
      .select('keywords.*', 'privmsg_counts.privmsg_count')
      .order('privmsg_count DESC', 'id DESC')
      .page(page)
  end

  def show
    @keyword = Keyword.friendly.find(params[:id])

    page_i = params[:page].to_i
    page = page_i >= 1 ? page_i : 1
    @logs = @keyword.privmsgs
      .page(page)
      .joins(:channel)
      .select(:channel_id, 'DATE(timestamp) AS date', 'channels.row_order')
      .distinct
      .order('date DESC', 'channels.row_order ASC')
      .preload(:channel)
  end
end

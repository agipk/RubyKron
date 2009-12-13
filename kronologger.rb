# Ruby API untuk Kronologger JSON API
# Agi Putra Kharisma agi[dot]banget[at]gmail[dot]com
# http://agilini.us
# versi 0.1.0
# license: Creative Commons Attribution-Share Alike 2.5

require 'rubygems'
require 'open-uri'
require 'json'
require 'net/http'

class Kronologger
  attr_accessor :postingid, :userid, :isipesan, :createpesan, :username, :photo
  
  BASE_URL = 'http://kronologger.com/AIR'
  URL = 'kronologger.com'
  @http = Net::HTTP.new(URL)
  
  # Menampilkan 20 posting terakhir
  def self.getLatestKrons
    kron = Kronologger.new
    krons = []
    krons_json = self.getKrons('/json_last_kron.php')
    krons_json.each do |k|
      kron = kron.clone
      kron.postingid = k['postingid']
      kron.userid = k['userid']
      kron.isipesan = k['isipesan']
      kron.createpesan = k['createpesan']
      kron.username = k['username']
      kron.photo = k['kron']
      krons << kron
    end
    krons
  end
  
  # Menampilkan komentar suatu posting
  def self.getKronComments(postingid)
    kronComm = KronologgerComment.new
    kronComms = []
    path = "/json_baca_komen.php?postingid=#{postingid}"
    kronComms_json = self.getKrons(path)
    kronComms_json.each do |kc|
      kronComm = kronComm.clone
      kronComm.trid = kc['trid']
      kronComm.username = kc['username']
      kronComm.postingid = kc['postingid']
      kronComm.userid = kc['userid']
      kronComm.response = kc['response']
      kronComm.kapan = kc['kapan']
      kronComms << kronComm
    end
    kronComms
  end
  
  # Update status
  def self.newKron(username, token, isipesan, ispingfm, isfacebook)
    path = '/AIR/json_update_status.php'
    data = "{\"username\":\"#{username}\",\"token\":\"#{token}\",\"isipesan\":\"#{isipesan}\",\"ispingfm\":\"#{ispingfm}\",\"isfacebook\":\"#{isfacebook}\"}"
    headers = { 'Content-Type' => 'application/json' }
    resp, data = @http.post(path, data, headers)
  end
  
  # Mengirim komentar untuk suatu posting
  def self.newKronComment(username, token, postingid, isirespond)
    path = '/AIR/json_post_komentar.php'
    data = "{\"username\":\"#{username}\",\"token\":\"#{token}\",\"postingid\":\"#{postingid}\",\"isirespond\":\"#{isirespond}\"}"
    headers = { 'Content-Type' => 'application/json' }
    resp, data = @http.post(path, data, headers)
  end
  
  private
  
  def self.getKrons(path)
    url = "#{BASE_URL}#{path}"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    result = JSON.parse(data)
    krons_json = result['kronologger']
  end
end

class KronologgerComment
  attr_accessor :trid, :username, :postingid, :userid, :response, :kapan
end

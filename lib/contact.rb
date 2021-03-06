# encoding: utf-8

class Contact < ActiveRecord::Base

  belongs_to :company, :foreign_key => Company.primary_key

  belongs_to :user,    :foreign_key => User.primary_key

  belongs_to :account, :foreign_key => Account.primary_key

  # Creates new contact_
  def initialize(params)
    super(params)

    if !self.companyid and self.user
      self.companyid = self.user.companyid
    end
    self.username ||= ''
    self.createdate   = Time.now
    self.modifieddate = Time.now
    if !self.accountid and self.company
      self.accountid = self.company.accountid
    end
    self.parentcontactid ||= 0
    self.firstname       ||= ''
    self.middlename      ||= ''
    self.lastname        ||= ''

    # values for prefixid and suffixid are defined in table listtype
    self.prefixid         ||= 0
    self.suffixid         ||= 0
    self.male=true if self.male.nil?
    self.birthday         ||= Time.mktime(1970,1,1)
    self.smssn            ||= ''
    self.aimsn            ||= ''
    self.icqsn            ||= ''
    self.jabbersn         ||= ''
    self.msnsn            ||= ''
    self.skypesn          ||= ''
    self.ymsn             ||= ''
    self.employeestatusid ||= ''
    self.employeenumber   ||= ''
    self.jobtitle         ||= ''
    self.jobclass         ||= ''
    self.hoursofoperation ||= ''
    self.facebooksn       ||= ''
    self.myspacesn        ||= ''
    self.twittersn        ||= ''

    self.save
  end

#   def save
#     if !self.username and self.firstname and self.lastname
#       self.username = fullname
#     end
#     super
#   end

  def fullname
    (self.firstname.empty? and self.lastname.empty?) ?
      'Guest' : self.firstname+' '+self.lastname
  end

end

package profile

type AuditLog struct {
	EventID        string  `json:"eventId"`
	EventCode      string  `json:"eventCode"`
	CifNo          string  `json:"cifNo"`
	Cid            string  `json:"cid" mask:"id"`
	CorrelationID  string  `json:"correlationId"`
	ChannelID      string  `json:"channelId"`
	IPAddress      string  `json:"ipAddress"`
	HTTPStatusCode string  `json:"httpStatusCode"`
	TimeStamp      string  `json:"timeStamp"`
	Details        Details `json:"details" mask:"struct"`
}

type Details struct {
	FromAccountNo     string  `json:"fromAccountNo" mask:"credit"`
	FromAccountNameTh string  `json:"fromAccountNameTh" mask:"name"`
	FromAccountNameEn string  `json:"fromAccountNameEn" mask:"name"`
	Method            string  `json:"method"`
	ToAccountNo       string  `json:"toAccountNo" mask:"credit"`
	ToAccountNameTh   string  `json:"toAccountNameTh" mask:"name"`
	ToAccountNameEn   string  `json:"toAccountNameEn" mask:"name"`
	TotalAmount       float64 `json:"totalAmount"`
	FromAccountName   string  `json:"fromAccountName" mask:"name"`
}

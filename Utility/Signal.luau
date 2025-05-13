local Signal = {}
Signal.__index = Signal

export type Connection = {
	Disconnect: () -> ()
}

export type SignalType = {
	Connect: (self: SignalType, callback: (...any) -> ()) -> Connection,
	Once: (self: SignalType, callback: (...any) -> ()) -> Connection,
	Fire: (self: SignalType, ...any) -> (),
	DisconnectAll: (self: SignalType) -> ()
}

function Signal.new(): SignalType
	local self = setmetatable({}, Signal)
	
	self._connections = {}
	self._onceConnections = {}
	
	return self
end

function Signal:Connect(callback: (...any) -> ()): Connection
	local connection = {
		_callback = callback,
		_connected = true,
		
		Disconnect = function(self)
			if not self._connected then
				return
			end
			
			self._connected = false
			
			for i, conn in ipairs(self._connections) do
				if conn == self then
					table.remove(self._connections, i)
					break
				end
			end
		end
	}
	
	connection._connections = self._connections
	table.insert(self._connections, connection)
	
	return connection
end

function Signal:Once(callback: (...any) -> ()): Connection
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		callback(...)
	end)
	
	table.insert(self._onceConnections, connection)
	
	return connection
end

function Signal:Fire(...)
	for _, connection in ipairs(table.clone(self._connections)) do
		if connection._connected then
			task.spawn(connection._callback, ...)
		end
	end
end

function Signal:DisconnectAll()
	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end
	
	self._connections = {}
	self._onceConnections = {}
end

function Signal:Destroy()
	self:DisconnectAll()
	
	setmetatable(self, nil)
end

return Signal
